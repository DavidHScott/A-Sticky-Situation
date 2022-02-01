extends Node2D

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

var current_page = UI_PAGES.WAREHOUSE
var current_game_state = GAME_STATE.DOWNTIME

const GOLDEN = "Golden"
const AMBER = "Amber"
const DARK = "Dark"
const VERY_DARK = "Very Dark"

var current_day = 0

signal slot_select(item)
signal clear_info_panel()
signal close_current_page()
signal open_new_page(ref_to_new_page)
signal game_state_switch()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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
			print("You done messed up A-Aron!")
			return
	
	# If so, unload current screen
	emit_signal("close_current_page")
	
	# Load new scene
	emit_signal("open_new_page", reference_to_new_scene)
	
	pass

# Game state switcher (From downtime to buying/selling)
func switch_game_state():
	if current_game_state == GAME_STATE.DOWNTIME:
		current_game_state = GAME_STATE.SHOPPING_TIME
		
		current_day += 1
		
		Market.new_day()
		ShoppingController.start_shop_day()
		
		emit_signal("game_state_switch")
	else:
		current_game_state = GAME_STATE.DOWNTIME
		
		ShoppingController.stop_shop_day()
		
		if current_page == UI_PAGES.BUY_SYRUP:
			switch_screen(UI_PAGES.WAREHOUSE)
		
		emit_signal("game_state_switch")

####### Inventory

# Slot selection
func slot_selected(item):
	emit_signal("slot_select", item)

# Remove item info from Item Info panel
func clear_item_info_panel():
	emit_signal("clear_info_panel")

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
