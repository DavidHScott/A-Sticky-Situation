extends Node2D

signal close_current_page()
signal open_new_page(ref_to_new_page)
signal game_state_switch()

enum GAME_STATE {
	DOWNTIME,
	SHOPPING_TIME
}

enum UI_PAGES {
	WAREHOUSE,
	ORDERS,
	BUY_SYRUP,
	MARKET
}

onready var warehouse_page = preload("res://scenes/gui_components/page_panels/WarehousePage.tscn")
onready var orders_page = preload("res://scenes/gui_components/page_panels/OrdersPage.tscn")
onready var buy_syrup_page = preload("res://scenes/gui_components/page_panels/BuySyrupPage.tscn")
onready var market_page = preload("res://scenes/gui_components/page_panels/MarketPage.tscn")

onready var golden_sprite = preload("res://assets/sprites/syrups/syrup_jug.png")
onready var amber_sprite = preload("res://assets/sprites/syrups/syrup_jug.png")
onready var dark_sprite = preload("res://assets/sprites/syrups/syrup_jug.png")
onready var very_dark_sprite = preload("res://assets/sprites/syrups/syrup_jug.png")

var current_page = null
var current_game_state = GAME_STATE.DOWNTIME

const GOLDEN = "Golden"
const AMBER = "Amber"
const DARK = "Dark"
const VERY_DARK = "V. Dark"

var current_day = 0

var unlocked_start_day = false
var unlocked_warehouse = false
var unlocked_market = false

var esc_button_stack = []


func _ready():
	Global.should_fade_to_main = true
	
	ShoppingController.load_producers_from_data()
	
	# Connect signals
	OrderFulfillment.connect("order_accepted", self, "check_accepted_order")
	OrderFulfillment.connect("order_fulfilled", self, "check_fulfilled_order")
	
	# Set variables from the save data
	OrderFulfillment.max_orders = SaveAndLoad.save_data.max_orders
	OrderFulfillment.generate_random_orders = SaveAndLoad.save_data.generate_random_orders
	
	current_day = SaveAndLoad.save_data.current_day
	
	PlayerVariables.username = SaveAndLoad.save_data.player_name
	PlayerVariables.money = SaveAndLoad.save_data.money
	PlayerVariables.reputation = SaveAndLoad.save_data.reputation
	PlayerVariables.inventory_size = SaveAndLoad.save_data.inventory_size
	
	PlayerVariables.available_warehouse_upgrades = SaveAndLoad.save_data.available_warehouse_upgrades
	PlayerVariables.upcoming_upgrade_costs = SaveAndLoad.save_data. upcoming_upgrade_costs
	
	SaveAndLoad.load_inv_from_savedata()
	
	# Unlock features
	unlocked_start_day = SaveAndLoad.save_data.unlocked_start_day
	unlocked_warehouse = SaveAndLoad.save_data.unlocked_warehouse
	unlocked_market = SaveAndLoad.save_data.unlocked_market
	
	interface_anim()


# TODO: It would be better to have this be data-driven instead of hardcoded as it is here
#
# Unlock features when a specific order is accepted
func check_accepted_order(order_slot):
	# Check the name of the order, and if something needs to happen, do that thing
	if order_slot.order_key == "???_0":
		unlocked_start_day = true
		unlocked_warehouse = true
		SaveAndLoad.save_data.unlocked_start_day = unlocked_start_day
		SaveAndLoad.save_data.unlocked_warehouse = unlocked_warehouse
		
		$GUI/Interface/LowerThird/StartDayTab.visible = true
		$GUI/Interface/LowerThird/WarehouseTab.visible = true		
	elif order_slot.order_key == "maxime_1":
		# First warehouse upgrade
		PlayerVariables.available_warehouse_upgrades += 1
	elif order_slot.order_key == "wyman_3":
		# Unlock market tab
		unlocked_market = true
		SaveAndLoad.save_data.unlocked_market = true
		
		SaveAndLoad.save_current_game()
	elif order_slot.order_key == "maxime_3":
		# Second warehouse upgrade
		PlayerVariables.available_warehouse_upgrades += 1
	elif order_slot.order_key == "???_3":
		end_game_sequence()


# (cont.) It would be better to have this be data-driven instead of hardcoded as it is here
#
# # Unlock features when a specific order is fulfilled
func check_fulfilled_order(order_key):
	if order_key == "wyman_2":
		# Unlock random orders
		OrderFulfillment.generate_random_orders = true
		SaveAndLoad.save_data.generate_random_orders = true
	elif order_key == "???_2":
		OrderFulfillment.generate_random_orders = false
		SaveAndLoad.save_data.generate_random_orders = false
		
		# Remove all orders other than ???_3
		for order_key in OrderFulfillment.available_quests.keys():
			if order_key == "???_3":
				continue
			
			OrderFulfillment.available_quests.erase(order_key)
		
		# Close all UI except for Orders
		slide_out_ui()
		
		# TODO: Play sound effects and fade out all music

func interface_anim():
	# This has no actual purpose atm. This is just here to give it an extra second for funsies
	$GUI/FadePanel.visible = true
	$GUI/FadePanel/AnimationPlayer.play("fade_to_screen")
	yield($GUI/FadePanel/AnimationPlayer, "animation_finished")
	$GUI/FadePanel.visible = false
	
	$GUI/Interface/UpperThird.visible = true
	yield($GUI/Interface/UpperThird/Tween, "tween_completed")
	
	if unlocked_warehouse:
		$GUI/Interface/LowerThird/WarehouseTab.visible = true
		yield($GUI/Interface/LowerThird/WarehouseTab/Tween, "tween_completed")
	if unlocked_market:
		$GUI/Interface/LowerThird/MarketTab.visible = true
		yield($GUI/Interface/LowerThird/MarketTab/Tween, "tween_completed")
	if unlocked_start_day:
		$GUI/Interface/LowerThird/StartDayTab.visible = true
		yield($GUI/Interface/LowerThird/StartDayTab/Tween, "tween_completed")
	
	$GUI/Interface/LowerThird/OrdersTab.visible = true
	yield($GUI/Interface/LowerThird/OrdersTab/Tween, "tween_completed")


func slide_out_ui():
	$GUI/Interface/UpperThird/PauseButton.disabled = true
	$GUI/Interface/LowerThird/WarehouseTab.disabled = true
	$GUI/Interface/LowerThird/MarketTab.disabled = true
	$GUI/Interface/LowerThird/StartDayTab.disabled = true
	$GUI/Interface/LowerThird/BuySyrupTab.disabled = true
	
	if $GUI/Interface/LowerThird/BuySyrupTab.visible == true:
		$GUI/Interface/LowerThird/BuySyrupTab/Tween.slide_down()
		yield($GUI/Interface/LowerThird/BuySyrupTab/Tween, "tween_completed")
	
	$GUI/Interface/LowerThird/StartDayTab.visible = true
	yield($GUI/Interface/LowerThird/StartDayTab/Tween, "tween_completed")
	
	$GUI/Interface/LowerThird/MarketTab.visible = true
	yield($GUI/Interface/LowerThird/MarketTab/Tween, "tween_completed")
	
	$GUI/Interface/LowerThird/WarehouseTab.visible = true
	yield($GUI/Interface/LowerThird/WarehouseTab/Tween, "tween_completed")
	
	$GUI/Interface/UpperThird.visible = true
	yield($GUI/Interface/UpperThird/Tween, "tween_completed")


func end_game_sequence():
	SaveAndLoad.save_data.beat_game = true
	SaveAndLoad.save_current_game()
	
	$GUI/FadePanel.visible = true
	$GUI/FadePanel/AnimationPlayer.play("fade_to_black", -1, 0.4)
	yield($GUI/FadePanel/AnimationPlayer, "animation_finished")
	
	$GUI/Interface.visible = false
	
	# Stop playing the sound effects
	
	# Open a menu
	$GUI/EndGamePanel.visible = true
	
	$GUI/FadePanel/AnimationPlayer.play("fade_to_screen", -1, 1)
	yield($GUI/FadePanel/AnimationPlayer, "animation_finished")
	$GUI/FadePanel.visible = false


# Screen switcher
func switch_screen(new_screen):
	var reference_to_new_scene
	
	# Check if new_screen is an existing screen
	match new_screen:
		UI_PAGES.WAREHOUSE:
			# Are we already on the screen?
			if current_page == UI_PAGES.WAREHOUSE:
				return
			
			# Assign the reference to the new scene
			reference_to_new_scene = warehouse_page
			current_page = UI_PAGES.WAREHOUSE
		UI_PAGES.MARKET:
			# Are we already on the screen?
			if current_page == UI_PAGES.MARKET:
				return
			
			# Assign the reference to the new scene
			reference_to_new_scene = market_page
			current_page = UI_PAGES.MARKET
		UI_PAGES.BUY_SYRUP:
			# Are we already on the screen?
			if current_page == UI_PAGES.BUY_SYRUP or current_game_state == GAME_STATE.DOWNTIME:
				return
			
			# Assign the reference to the new scene
			reference_to_new_scene = buy_syrup_page
			current_page = UI_PAGES.BUY_SYRUP
		UI_PAGES.ORDERS:
			# Are we already on the screen?
			if current_page == UI_PAGES.ORDERS:
				return
			
			reference_to_new_scene = orders_page
			current_page = UI_PAGES.ORDERS
		_:
			print("Game::Error: Trying to switch to a page that doesn't exist!")
			return
	
	# unload current screen
	emit_signal("close_current_page")
	
	# Load new scene
	emit_signal("open_new_page", reference_to_new_scene)


# Game state switcher (From downtime to buying/selling)
func switch_game_state():
	if current_game_state == GAME_STATE.DOWNTIME:
		current_game_state = GAME_STATE.SHOPPING_TIME
		
		current_day += 1
		SaveAndLoad.save_data.current_day = current_day
		
		Market.new_day()
		ShoppingController.start_shop_day()
		OrderFulfillment.start_day()
		
		emit_signal("game_state_switch")
	else:
		current_game_state = GAME_STATE.DOWNTIME
		
		ShoppingController.stop_shop_day()
		OrderFulfillment.end_day()
		
		if current_page == UI_PAGES.BUY_SYRUP:
			switch_screen(UI_PAGES.WAREHOUSE)
		
		emit_signal("game_state_switch")
	
	SaveAndLoad.save_current_game()


# Get the sprite for the specific syrup grade
func get_syrup_sprite(grade):
	if grade == GOLDEN:
		return golden_sprite
	elif grade == AMBER:
		return amber_sprite
	elif grade == DARK:
		return dark_sprite
	elif grade == VERY_DARK:
		return very_dark_sprite
	else:
		return null


# Page should be a UI_PAGES enum var
func page_notification(page):
	$GUI/Interface.page_notification(page)
