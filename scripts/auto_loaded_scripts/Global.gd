extends Node2D

const GOLDEN = "Golden"
const AMBER = "Amber"
const DARK = "Dark"
const VERY_DARK = "Very Dark"

var current_day = 0

signal slot_select(item)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Screen switcher


# Game state switcher (From downtime to buying/selling)


####### Inventory

# Slot selection
func slot_selected(item):
	emit_signal("slot_select", item)

# Sell price calculation
func get_item_sell_price(item):
	var sell_price = item.get_buy_price() * 1.5
	
	return sell_price
	pass

# Compare items to see if stackable

