extends Node

var shop = []

var possible_producers = []

signal shop_slot_select(item_index)

signal start_shop_timer()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func slot_selected(item_index):
	emit_signal("shop_slot_select", item_index)

func start_shop_day():
	# Generate 4 buyable items and add them to the shop
	
	# Start timer
	emit_signal("start_shop_timer")
	
	pass

# Every 15 seconds, check if an item can be added to the shop

func stop_shop_day():
	pass
