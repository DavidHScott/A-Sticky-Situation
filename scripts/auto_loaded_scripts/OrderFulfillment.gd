extends Node

var placeholder_quest = Order.new("Quest Name!", "Flor-Stor", 
	"Wow, this is a really specific order. Want some interesting backstory? Did you know about X event?",
	1500, [Item.new(Global.AMBER, null, 70, 2)], 0, 0)

var story_orders_dict = {
	"main_0": placeholder_quest
}

var available_quests = []

signal order_slot_select(slot)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start_day():
	pass

func select_order_slot(slot):
	emit_signal("order_slot_select", slot)
