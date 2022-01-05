extends Node

var shop = []

signal shop_slot_select(item_index)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func slot_selected(item_index):
	emit_signal("shop_slot_select", item_index)

func start_shop_day():
	pass
	
func stop_shop_day():
	pass
