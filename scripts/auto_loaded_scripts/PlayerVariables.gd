extends Node2D

var money = 5000

var inventory = []
var inventory_size = 8

signal money_was_updated(new_total)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Clear the inventory
	for i in inventory_size-1:
		inventory.append(null)
	
	var newItem = Item.new()
	
	newItem.set_grade(Global.DARK)
	newItem.set_producer("Test Prod")
	newItem.set_quality(80)
	newItem.set_buy_price(5000)
	newItem.set_quantity(96)
	
	inventory[4] = newItem
	# Set the money counter

func get_players_money():
	return money

func set_players_money(new_money):
	money = new_money
	## Reset UI

func increment_players_money(new_money):
	money += new_money
	emit_signal("money_was_updated", money)
