extends Node


var rng = RandomNumberGenerator.new()

var temp_rand_order_1 = Order.new("RAND_1", "PLACEHOLDER", "PLACEHOLDER", 1000, null, 1, 3, null, 0, 1, 0)
var temp_rand_order_2 = Order.new("RAND_2", "PLACEHOLDERRR", "PLACEHOLDER", 2000, null, 1, 3, null, 0, 1, 0)

var story_orders_dict = { }

var random_orders_dict = {
	"rand_1": temp_rand_order_1,
	"rand_2": temp_rand_order_2
}

# Orders that the player can see, accepted & unaccepted
var available_quests = { }

# New orders come in after a work day, so this acts as a cache
var order_purgatory = { }

# Orders that the player previously completed or failed
var previous_quests = { }

signal order_slot_select(slot)
signal refresh_order_panel()
signal remove_order()
signal order_accepted(order_key)
signal order_fulfilled(order_key)

var thread

var max_orders = 2
var generate_random_orders = false


func _ready():
	load_main_orders_to_dict()
	

# Get the main order data and load all orders into a dictionary
func load_main_orders_to_dict():
	for order_key in ImportData.main_order_data.keys():
		var order_dict = ImportData.main_order_data[order_key]
		
		var title = order_dict["Title"]
		var distrib = order_dict["Distributer"]
		var description = order_dict["Description"]
		var pay = order_dict["Payment"]
		
		var timelimit = order_dict["AcceptTimelimit"]
		var deadline = order_dict["Deadline"]
		
		var require_arr
		var prereq_arr = order_dict["Prereq"]
		
		var wait = order_dict["wait_day_to_unlock"]
		
		var reward_reputation = order_dict["RepReward"]
		var required_reputation = order_dict["RequiredRep"]
		
		if order_dict["Requirements"] == null:
			require_arr = null
		else:
			require_arr = []
			
			for item in order_dict["Requirements"]:
				var new_item = Item.new(item["ItemGrade"], item["ItemProducer"], item["ItemQuality"], item["ItemQuantity"])
				
				require_arr.append(new_item)
		
		
		var new_quest = Order.new(title, distrib, description, pay, require_arr, timelimit, deadline, prereq_arr, wait, reward_reputation, required_reputation)
		story_orders_dict[order_key] = new_quest


func start_day():
	pass


func end_day():
	for order in available_quests.values():
		order.new_day()
		
		if order.expired:
			order.queue_free()
	
	unlock_any_new_orders()
	
	# Check if we can generate some new orders, and if so, fill up the queue
	if generate_random_orders:
		while available_quests.size() < max_orders:
			generate_random_order()
	
	if Global._game().current_page == Global._game().UI_PAGES.ORDERS:
		# TODO: instead of completely refreshing, call animations to play for new orders
		order_purgatory.clear()
		refresh_order_panel_ui()
	else:
		order_purgatory.clear()


# SHOULD BE IN EVENT BUS
func select_order_slot(slot):
	emit_signal("order_slot_select", slot)


# SHOULD BE IN EVENT BUS
func order_accepted(order_key):
	emit_signal("order_accepted", order_key)


# SHOULD BE IN EVENT BUS
func order_fulfilled(order_key):
	emit_signal("order_fulfilled", order_key)


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

func fulfill_order(order_key:String, item_arr):
	
	if item_arr != null:
		# Connect to PlayerVariables to remove items from inventory
		# Give player the monies
		PlayerVariables.remove_item_array_from_inv(item_arr)
		
		# Check if the player should have pay penalty
		if !available_quests[order_key].overdue:
			PlayerVariables.increment_players_money(available_quests[order_key].pay)
		else:
			PlayerVariables.increment_players_money(available_quests[order_key].overdue_pay)
	
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
	
	# unlock any new orders
	unlock_new_orders(order_key)
	
	refresh_order_panel_ui()


# Go through ALL of the previous orders and unlock any orders. This is called at the end of every day
#
# This is mainly just here for if I expand the game and add more content. Though if this ends up
#	being an issue, This can be changed to only be called when loading a save, and saving a cache
#	of the most recent fulfilled orders, and calling unlock_new_orders with that
#
## TODO: Should this runs on a seperate thread?
func unlock_any_new_orders():
	for order_key in previous_quests.keys():
		unlock_new_orders(order_key)


# Takes the key of an order that has been completed and checks if any new orders can be unlocked.
#
# params:
#	prereq_key - the key of a completed order
#
## TODO: Refactor this maybe? This whole system is a bit of a mess lol
func unlock_new_orders(prereq_key):
	
	for order in story_orders_dict:
		# Check if order was already completed or is already available to the player
		if previous_quests.has(order) or available_quests.has(order):
			continue
		# Make sure the player has enough reputation
		if story_orders_dict[order].required_reputation > PlayerVariables.reputation:
			continue
		
		# Start by unlocking anything with a null prereq
		if story_orders_dict[order].prereq_keys == null:
			# We've already checked reputation, so the order can just be added
			available_quests[order] = story_orders_dict.get(order)
			
			if story_orders_dict[order].wait_day_to_unlock != 0:
				order_purgatory[order] = story_orders_dict.get(order)
			
			continue
		
		# Start checking prereqs
		if story_orders_dict[order].prereq_keys.has(prereq_key):
			# Check if there's more than one prereq. If so, make sure both prereqs are fulfilled
			if story_orders_dict[order].prereq_keys.size() > 1:
				
				if !loop_through_prereqs(story_orders_dict[order]):
					continue
			
			# If we haven't continued the loop at this point, the order can be added
			available_quests[order] = story_orders_dict.get(order)
			
			if story_orders_dict[order].wait_day_to_unlock != 0:
				order_purgatory[order] = story_orders_dict.get(order)


# Loop through an order's prereq keys. returns true or false if the order can be unlocked
func loop_through_prereqs(order):
	for prereq_order in order.prereq_keys:
		if !previous_quests.keys().has(prereq_order):
			return false
	
	return true


#
func generate_random_order():
	# Pick a random order
	rng.randomize()
	var rand_i = rng.randi_range(0, random_orders_dict.size() - 1)
	
	var new_key = random_orders_dict.keys()[rand_i]
	
	# Add it to the available orders
	available_quests[new_key] = random_orders_dict[new_key]


func refresh_order_panel_ui():
	emit_signal("refresh_order_panel")


func inc_max_orders(o):
	max_orders =+ o
	SaveAndLoad.save_data.max_orders = max_orders


func set_max_orders(o):
	max_orders = o
	SaveAndLoad.save_data.max_orders = max_orders


#### ARRAY SORT
class InventoryArraySorter:
	static func sort_by_buy_price(a, b):
		if a.buy_price < b.buy_price:
			return true
		return false
