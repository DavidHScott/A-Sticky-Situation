extends Node2D

var username:String

var money:int = 5000
var reputation:int = 0

var inventory:Array
var inventory_size:int = 8

signal money_was_updated(new_total)


func get_players_money():
	return money

func set_players_money(new_money):
	money = new_money
	emit_signal("money_was_updated", money)
	
	SaveAndLoad.save_data.money = money

func increment_players_money(new_money):
	money += new_money
	emit_signal("money_was_updated", money)
	
	SaveAndLoad.save_data.money = money

func update_inventory_size(new_size:int):
	inventory_size = new_size
	# TODO: If the new size is smaller, remove some items
	
	SaveAndLoad.save_data.inventory_size = inventory_size

func inc_inventory_size(new_size:int):
	inventory_size += new_size
	# TODO: If the new size is smaller, remove some items
	
	SaveAndLoad.save_data.inventory_size = inventory_size

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
	
	SaveAndLoad.save_inv_to_savedata()

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
			
			if inv_item.quantity < 1:
				inv_item = null
	
	if succeeded == false:
		print("Tried to remove an item not in the inventory!")
		return false
	
	SaveAndLoad.save_inv_to_savedata()
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


# Warehouse functions
# Slot selection
func slot_selected(item):
	emit_signal("slot_select", item)

# Remove item info from Item Info panel
func clear_item_info_panel():
	emit_signal("clear_info_panel")
