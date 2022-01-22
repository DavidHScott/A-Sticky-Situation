extends Node

# Prices assume 100/100 quality
var current_amber_price = 100
var current_golden_price = 100
var current_dark_price = 100
var current_verydark_price = 100

var amber_price_history = []
var golden_price_history = []
var dark_price_history = []
var verydark_price_history = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# TEMP
func randomise_prices():
	current_amber_price = randi() % 1000
	current_golden_price = randi() % 1000
	current_dark_price = randi() % 1000
	current_verydark_price = randi() % 1000

func new_day():
	amber_price_history.append(current_amber_price)
	golden_price_history.append(current_golden_price)
	dark_price_history.append(current_dark_price)
	verydark_price_history.append(current_verydark_price)

func get_item_price(item):
	
	var item_price
	
	if item.get_grade() == Global.AMBER:
		item_price = current_amber_price
	elif item.get_grade() == Global.GOLDEN:
		item_price = current_golden_price
	elif item.get_grade() == Global.DARK:
		item_price = current_dark_price
	elif item.get_grade() == Global.VERY_DARK:
		item_price = current_verydark_price
	else:
		return
	
	return item_price