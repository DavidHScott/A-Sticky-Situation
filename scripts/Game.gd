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
const VERY_DARK = "Very Dark"

var current_day = 0

var unlocked_start_day = false
var unlocked_warehouse = false

func _ready():
	# Connect signals
	OrderFulfillment.connect("order_accepted", self, "check_accepted_order")
	OrderFulfillment.connect("order_fulfilled", self, "check_fulfilled_order")
	
	# Set variables from the save data
	OrderFulfillment.max_orders = SaveAndLoad.save_data.max_orders
	OrderFulfillment.generate_random_orders = SaveAndLoad.save_data.generate_random_orders
	
	current_day = SaveAndLoad.save_data.current_day
	
	PlayerVariables.name = SaveAndLoad.save_data.player_name
	PlayerVariables.money = SaveAndLoad.save_data.money
	PlayerVariables.inventory_size = SaveAndLoad.save_data.inventory_size
	
	PlayerVariables.available_warehouse_upgrades = SaveAndLoad.save_data.available_warehouse_upgrades
	PlayerVariables.upcoming_upgrade_costs = SaveAndLoad.save_data. upcoming_upgrade_costs
	
	SaveAndLoad.load_inv_from_savedata()
	
	# Unlock features
	unlocked_start_day = SaveAndLoad.save_data.unlocked_start_day
	unlocked_warehouse = SaveAndLoad.save_data.unlocked_warehouse
	
	limit_functions()
	


# TODO: It would be better to have this be data-driven instead of hardcoded as it is here
#
# Unlock features when a specific order is accepted
func check_accepted_order(order_key):
	# Check the name of the order, and if something needs to happen, do that thing
	if order_key == "???_0":
		unlocked_start_day = true
		unlocked_warehouse = true
		SaveAndLoad.save_data.unlocked_start_day = unlocked_start_day
		SaveAndLoad.save_data.unlocked_warehouse = unlocked_warehouse
		
		$GUI/Interface/LowerThird/StartDayTab.visible = true
		$GUI/Interface/LowerThird/Left/WarehouseTab.visible = true


# (cont.) It would be better to have this be data-driven instead of hardcoded as it is here
#
# # Unlock features when a specific order is fulfilled
func check_fulfilled_order(order_key):
	if order_key == "wyman_2":
		# Unlock random orders
		OrderFulfillment.generate_random_orders = true
		SaveAndLoad.save_data.generate_random_orders = true


func limit_functions():
	if unlocked_start_day:
		$GUI/Interface/LowerThird/StartDayTab.visible = true
	
	if unlocked_warehouse:
		$GUI/Interface/LowerThird/Left/WarehouseTab.visible = true


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
			print("Error: Game::Trying to switch to a page that doesn't exist!")
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
