extends Node

var shop = []

var producers_dict = { }

var habit_percentages = [0.8, 0.9, 1, 1.1, 1.2]

var shop_generation_timer

var selected_item_index = null
var selected_slot = null

signal shop_slot_select(item_index)
signal start_shop_timer()
signal refresh_shop_ui()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called when starting a new game and loading a saved game.
#
# When loading a saved game, this is called after producers are loaded from save data,
# 	So no save data is overridden, but if something is added in an update or user mod
# 	it can still be added
func load_producers_from_data():
	for abr_name in ImportData.producer_data.keys():
		# First check if the producer is already in the dict.
		if producers_dict.has(abr_name):
			continue
		
		var prod_dict = ImportData.producer_data[abr_name]
		
		var fullname = prod_dict["FullName"]
		var active_on_load = prod_dict["Active"]
		var pricing_habits = prod_dict["PricingHabits"]
		
		var restriction_grades = prod_dict["Restrictions"]["Grades"]
		var restriction_min_qual = prod_dict["Restrictions"]["MinQuality"]
		var restriction_max_qual = prod_dict["Restrictions"]["MaxQuality"]
		
		var new_producer = Producer.new(abr_name, fullname, active_on_load, pricing_habits,
			restriction_grades, restriction_min_qual, restriction_max_qual)
		
		producers_dict[abr_name] = new_producer
	
	SaveAndLoad.save_producers_to_file(SaveAndLoad.save_data)


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
	for i in 20:
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
	rand = randi() % producers_dict.size()
	var producer_key = producers_dict.keys()[rand]
	var producer:Producer = producers_dict[producer_key]
	
	# Redo it if the producer isn't active
	while producer.active == false:
		rand = randi() % producers_dict.size()
		producer_key = producers_dict.keys()[rand]
		producer = producers_dict[producer_key]
	
	new_item.producer = producer_key
	
	rand = (randi() % int((producer.maximum_quality + 1) - producer.minimum_quality)) + producer.minimum_quality
	new_item.set_quality(rand)
	
	# Generate the buy price
	var buy_price = generate_buy_price(new_item)
	new_item.set_buy_price(buy_price)
	
	# Set shop quantity
	# TODO: Set this based on date and market value?
	rand = (randi() % 20) + 1
	new_item.set_quantity(rand)
	return new_item


func insert_items_into_shop(items_arr:Array):
	for item in items_arr:
		var new_item = Item.new()
		var rand
		
		# What grade does it need to be?
		if item.grade != null:
			new_item.grade = item.grade
		else:
			# If no requirement, randomize it
			rand = randi() % 4
			match rand:
				0:
					new_item.set_grade(Global._game().AMBER)
				1:
					new_item.set_grade(Global._game().GOLDEN)
				2:
					new_item.set_grade(Global._game().DARK)
				3:
					new_item.set_grade(Global._game().VERY_DARK)
		
		# Does it have a producer requirement?
		
		if item.producer != null:
			new_item.producer = item.producer
		else:
			rand = randi() % producers_dict.size()
			var producer_key = producers_dict.keys()[rand]
			
			new_item.producer = producer_key
		
		# Does it have a quality requirement?
		if item.quality != null:
			rand = randi() % int(101 - item.quality) + item.quality
			new_item.set_quality(rand)
		else:
			# Default to the producer's quality range
			var producer:Producer = producers_dict[new_item.producer]
			
			rand = (randi() % int((producer.maximum_quality + 1) - producer.minimum_quality)) + producer.minimum_quality
			new_item.set_quality(rand)
		
		# Eventually when I feel like it, this should change so multiple differnet listings can be
		# 	created that fill the requirements if the first generation doesn't have enough.
		#
		# Also this has the issue of if there is ever an order with more than 20 quantity of an item, 
		# 	it won't generate enough in one day. Though it won't softlock as it will generate more
		#	on subsequent days, but it might force the pay to be penalized
		rand = (randi() % int(21 - item.quantity)) + item.quantity
		new_item.set_quantity(rand)
		
		var buy_price = generate_buy_price(new_item)
		new_item.set_buy_price(buy_price)
		
		shop.append(new_item)
	
	# All items have been generated, randomize the shop array so it's not all just on the bottom
	shop.shuffle()


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


func generate_buy_price(item:Item):
	var percent_modifier
	
	# I basically played around on WolframAlpha for a little while and came up with this.
	#	It's not amazing, and I'll probably change it at some point, but it has the general vibe
	# 	I'm going for
	var x = item.quality / 100
	
	if x < 0.7:
		percent_modifier = pow(x, 1.6)
	if x >= 0.7:
		percent_modifier = x + 0.1
	
	# Round the numbers to make it a bit nicer to use
	if percent_modifier > 1.0:
		percent_modifier = 1.0
	elif percent_modifier < 0.15:
		percent_modifier = 0.15
	
	# Take the above. How much will the producer over/under-charge for it?
	var producer:Producer = producers_dict[item.producer]
	percent_modifier *= habit_percentages[producer.price_habits]
	
	# Get the current market price for the relavent grade
	var market_price
	
	if item.grade == Global._game().GOLDEN:
		market_price = Market.golden_trend.current_base_price
	elif item.grade == Global._game().AMBER:
		market_price = Market.amber_trend.current_base_price
	elif item.grade == Global._game().DARK:
		market_price = Market.dark_trend.current_base_price
	elif item.grade == Global._game().VERY_DARK:
		market_price = Market.verydark_trend.current_base_price
	else:
		market_price = 800
		print("ShoppingController::Error: Tried to generate buy price for an item with an undefined grade.")
	
	# And put it all together :D
	var buy_price = market_price * percent_modifier
	buy_price = int(round(buy_price))
	
	return buy_price
