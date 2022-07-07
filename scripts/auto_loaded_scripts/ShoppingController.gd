extends Node

var shop = []

var possible_producers = ["Test Producer", "Sugar Shack inc."]

var shop_generation_timer

# var shop_max_items = 6

var selected_item_index = null
var selected_slot = null

signal shop_slot_select(item_index)
signal start_shop_timer()
signal refresh_shop_ui()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

## Select an item in the shop
func slot_selected(item_slot):
	selected_item_index = item_slot.item_index
	emit_signal("shop_slot_select", selected_item_index)


## Start the day, and start generating items
func start_shop_day():
	# Start timer
	emit_signal("start_shop_timer")
	
	shop.clear()
	
	# Generate 4 random items
	for i in 4:
		shop.append(generate_shop_item())
	
	# Start time for generating new products throughout the day
	shop_generation_timer = Timer.new()
	shop_generation_timer.connect("timeout", self, "on_shop_generation_timer_timeout")
	shop_generation_timer.wait_time = 15
	
	add_child(shop_generation_timer)
	shop_generation_timer.start()

## Every 15 seconds, check if an item can be added to the shop
func on_shop_generation_timer_timeout():
	shop.append(generate_shop_item())
	
	shop_generation_timer.wait_time = (randi() % 11) + 10
	
	emit_signal("refresh_shop_ui", false)

## Clear the shop at the end of the day
func stop_shop_day():
	shop.clear()
	pass

## Generate shop items
func generate_shop_item():
	# Create the item
	var new_item = Item.new()
	# Generate the grade
	var rand = randi() % 4
	match rand:
		0:
			new_item.set_grade(Global._game().AMBER)
		1:
			new_item.set_grade(Global._game().GOLDEN)
		2:
			new_item.set_grade(Global._game().DARK)
		3:
			new_item.set_grade(Global._game().VERY_DARK)
	
	# Generate the producer
	rand = randi() % possible_producers.size()
	new_item.set_producer(possible_producers[rand])
	
	# Generate the quality
	# TODO: Weigh the score somewhere on the higher end, and
	# allow some producers to generally have better product
	rand = (randi() % 100) + 1
	new_item.set_quality(rand)
	
	# Generate the buy price
	# TODO: make it based on producer, quality, and current market value
	#	The "average" price of a 10 gallon barrel of syrup should START at ~$800
	#	Low quality goods generally drop in price sharply
	#	Some producers will sell for slightly higher and some sell for lower
	#	And market value adjusts whatevers left
	#
	#	Most likely this will be calculated as a percentage (e.g. 1.0 * qual * prod * market)
	#	And then the actual price is calculated from that
	rand = (randi() % 1601) + 100
	new_item.set_buy_price(rand)
	
	# Set shop quantity
	# TODO: Set this based on date and market value?
	rand = (randi() % 20) + 1
	new_item.set_quantity(rand)
	return new_item

## Shop item gets sold
func sell_shop_item(quantity_sold):
	var new_item = shop[selected_item_index]
	
	# Make sure there's room in player inventory
	var inv_slot_index = PlayerVariables.inventory.find(null)
	if inv_slot_index == -1:
		# No empty spot
		return
	
	# Make sure player has enough money
	if PlayerVariables.get_players_money() < new_item.get_buy_price() * quantity_sold:
		return
	
	# Remove money from player
	PlayerVariables.increment_players_money(-new_item.get_buy_price() * quantity_sold)
	
	var new_inv_item = Item.new()
	new_inv_item.copy_item(new_item)
	new_inv_item.set_quantity(quantity_sold)
	
	# Give item to player
	PlayerVariables.add_item_to_inv(new_inv_item)
	
	new_item.set_quantity(new_item.get_quantity() - quantity_sold)
	
	if new_item.get_quantity() < 1:
		# Remove the item from the array
		shop.remove(selected_item_index)
		
		selected_item_index = null
		selected_slot = null
		
		emit_signal("refresh_shop_ui", true)
	else:
		emit_signal("shop_slot_select", selected_item_index)
	
	SaveAndLoad.save_current_game()
