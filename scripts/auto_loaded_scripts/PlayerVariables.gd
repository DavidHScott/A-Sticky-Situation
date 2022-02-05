extends Node2D

var money = 5000

var inventory = []
var inventory_size = 8

signal money_was_updated(new_total)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Clear the inventory
	inventory.resize(8)
	
	var newItem = Item.new()
	
	newItem.set_grade(Global.AMBER)
	newItem.set_producer("Test Prod")
	newItem.set_quality(90)
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

func add_item_to_inv(new_item):
	# Go through and check if there is an item currently in the 
	# inventory that the new item can stack with
	for item in inventory:
		if item != null:
			if item.compare_items(new_item):
				item.set_quantity(item.get_quantity() + new_item.get_quantity())
				return
	
	# If there isn't an item in tnv to stack with, add it to an empty spot
	var index = inventory.find(null)
	
	inventory[index] = new_item

# if item quantity is 0, remove all of item
func remove_item_from_inv(item:Item):
	var succeeded = false
	
	for inv_item in inventory:
		# Don't need to compare empty slots
		if inv_item == null:
			continue
		
		if inv_item.compare_items(item):
			# Found the item!
			succeeded = true
			
			if item.quantity == 0:
				# Remove entire stack from inventory
				inv_item = null
			else:
				# Remove item.quantity from the stack
				inv_item.quantity -= item.quantity
	
	if succeeded == false:
		print("Tried to remove an item not in the inventory!")
		return false
	return true

func remove_item_array_from_inv(item_arr:Array):
	var succeeded = true
	
	for item in item_arr:
		succeeded = remove_item_from_inv(item)
		
		if succeeded:
			continue
		else:
			break
	
	if succeeded == false:
		print("Tried to remove an item not in the inventory!")
