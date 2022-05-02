extends Node

var placeholder_quest = Order.new("Quest Name!", "Flor-Stor", 
	"Wow, this is a really specific order. Want some interesting backstory? Did you know about X event?",
	1500, [Item.new("Amber", null, 0, 2)], 0, 0)
	
var story_orders_dict = {
	"main_0": placeholder_quest
}

var random_orders_dict = { }

# Orders that the player can see, accepted & unaccepted
var available_quests = {
	
}

# Orders that the player previously completed or failed
var previous_quests = {
	
}

signal order_slot_select(slot)
signal refresh_order_panel()
signal remove_order()

func start_day():
	pass

func select_order_slot(slot):
	emit_signal("order_slot_select", slot)

func can_be_fulfilled(order_key:String):
	var inventory_copy:Array
	
	# remove all null items in array before anything else
	for item in PlayerVariables.inventory:
		if item == null:
			continue
		else:
			var new_item = Item.new()
			new_item.copy_item(item)
			
			inventory_copy.append(new_item)
	
	if inventory_copy.size() > 1:
		inventory_copy.sort_custom(InventoryArraySorter, "sort_by_buy_price")
	
	var item_arr = []
	
	# Iterate through every required item
	for req_item in available_quests[order_key].requirements:
		var found_amount = 0
		var found = false
		
		for inv_item in inventory_copy:
			# Make sure we're looking at an acutal item and not a null
			# space in the inventory array
			if inv_item == null:
				continue
			
			# Compare grade
			if req_item.grade != null and req_item.grade != inv_item.grade:
				continue
			
			# Compare quality
			if (req_item.quality != null) and (req_item.quality > inv_item.quality):
				continue
			
			# If the program gets to this point, the item is required.
			# Make a copy because using references makes things difficult
			var new_item = Item.new()
			new_item.copy_item(inv_item)
			
			# There may not be enough of the item in one stack. But multiple items that all
			# fit the qualifications is still fine
			if found_amount + new_item.quantity == req_item.quantity:
				inventory_copy.erase(inv_item)
				
				found = true
				item_arr.append(new_item)
				
				break
			elif found_amount + new_item.quantity > req_item.quantity:
				found = true
				
				var n = found_amount + new_item.quantity - req_item.quantity
				new_item.quantity -= n
				
				item_arr.append(new_item)
				
				# Leave the item with the leftover quantity
				inv_item.quantity = n
				
				break
			
			found_amount += new_item.quantity
			item_arr.append(new_item)
			inventory_copy.erase(inv_item)
		
		# if made to this point, the item has either been found, or all items have been checked
		if found == false:
			return null
		else:
			continue
	
	# Return an array of the items to be sold if the player fulfills the order
	return item_arr

func fulfill_order(order_key:String, item_arr:Array):
	# Connect to PlayerVariables to remove items from inventory
	# Give player the monies
	PlayerVariables.remove_item_array_from_inv(item_arr)
	PlayerVariables.increment_players_money(available_quests[order_key].pay)
	
	previous_quests[order_key] = available_quests[order_key]
	
	# Set the order as fulfilled
	# Remove the order from available orders
	available_quests[order_key].complete_order()
	available_quests.erase(order_key)
	
	SaveAndLoad.save_data.available_quest_keys.clear()
	SaveAndLoad.save_data.previous_quest_keys.clear()
	
	for key in available_quests.keys():
		SaveAndLoad.save_data.available_quest_keys[key] = available_quests[key].accepted
	
	for key in previous_quests.keys():
		SaveAndLoad.save_data.previous_quest_keys[key] = previous_quests[key].completed
	
	SaveAndLoad.save_current_game()
	
	# Remove the order from the menu
	emit_signal("remove_order")
	refresh_order_panel_ui()

func refresh_order_panel_ui():
	emit_signal("refresh_order_panel")


#### ARRAY SORT
class InventoryArraySorter:
	static func sort_by_buy_price(a, b):
		if a.buy_price < b.buy_price:
			return true
		return false
