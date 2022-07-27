extends Node

var initial_money = 2000
var initial_inventory_size = 8
var initial_order = "???_0"

const SAVE_FOLDER = "user://saves"
const SAVE_DIR_TEMPLATE = "%s_userdata%s"
const SAVE_NAME_TEMPLATE = "%s_userdata%s.res"

const OPTIONS_FILE = "user://options.res"

var save_data = SaveData.new()
var options = Options.new()


func _ready():
	var dir = Directory.new()
	dir.open("user://")
	
	# Make sure essential files and folders exist
	#
	# Check for the options file
	if ResourceLoader.exists(OPTIONS_FILE):
		# Load the saved options file
		options = ResourceLoader.load(OPTIONS_FILE)
	else:
		# The options resource has all the boilerplate settings by default, so save it
		ResourceSaver.save(OPTIONS_FILE, options)
	
	# Check for saves directory
	if !dir.dir_exists(SAVE_FOLDER):
		dir.make_dir("saves")
	
	
	if options.fullscreen == true:
		OS.window_fullscreen = true

func create_new_save(username:String):
	# Reset the save_data resource to new game variables
	clear_save_game()
	
	save_data.player_name = username
	
	var filename:String
	var directoryname:String
	var file = File.new()
	var directory = Directory.new()
	var save_path
	
	if directory.dir_exists(SAVE_FOLDER.plus_file(SAVE_DIR_TEMPLATE % [username, ""])):
		var id = 1
		
		while directory.dir_exists(SAVE_FOLDER.plus_file(SAVE_DIR_TEMPLATE % [username, "_" + str(id)])):
			id += 1
		
		directoryname = SAVE_DIR_TEMPLATE % [username, "_" + str(id)]
		directory.make_dir(SAVE_FOLDER.plus_file(directoryname))
		directory.make_dir(SAVE_FOLDER.plus_file(directoryname).plus_file("Producers"))
		
		filename = directoryname.plus_file(SAVE_NAME_TEMPLATE % [username, "_" + str(id)])
	else:
		directoryname = SAVE_DIR_TEMPLATE % [username, ""]
		directory.make_dir(SAVE_FOLDER.plus_file(directoryname))
		directory.make_dir(SAVE_FOLDER.plus_file(directoryname).plus_file("Producers"))
		
		filename = directoryname.plus_file(SAVE_NAME_TEMPLATE % [username, ""])
	
	save_path = SAVE_FOLDER.plus_file(filename)
	save_data.filename = filename
	
	save_data.golden_trend_filename = directoryname.plus_file("golden_trend.res")
	save_data.amber_trend_filename = directoryname.plus_file("amber_trend.res")
	save_data.dark_trend_filename = directoryname.plus_file("dark_trend.res")
	save_data.verydark_trend_filename = directoryname.plus_file("verydark_trend.res")
	
	# Set the date of creation
	var modified_date = OS.get_datetime()
	save_data.last_modified["Day"] = modified_date["day"]
	save_data.last_modified["Month"] = modified_date["month"]
	save_data.last_modified["Year"] = modified_date["year"]
	
	# TODO: Add proper error handling
	assert(ResourceSaver.save(save_path, save_data) == OK)
	
	return save_data


func load_save(filename):
	if ResourceLoader.exists(SAVE_FOLDER.plus_file(filename)):
		save_data = ResourceLoader.load(SAVE_FOLDER.plus_file(filename))
		load_inv_from_savedata()
		load_orders_from_savedata()
		
		return save_data


func save_current_game():
	# Not sure where I want to save this so here it goes!
	save_producers_to_file(save_data)
	
	# Keep the inventory and orders up to date
	save_inv_to_savedata()
	save_orders_to_savedata()
	
	var modified_date = OS.get_datetime()
	save_data.last_modified["Day"] = modified_date["day"]
	save_data.last_modified["Month"] = modified_date["month"]
	save_data.last_modified["Year"] = modified_date["year"]
	
	ResourceSaver.save(SAVE_FOLDER.plus_file(save_data.filename), save_data)

# Clear the save game to the default new game settings
func clear_save_game():
	save_data.save_data_version = Global.current_game_version
	save_data.filename = ""
	
	# Player data
	save_data.player_name = ""
	save_data.money = initial_money
	save_data.reputation = 0
	save_data.inventory_size = initial_inventory_size
	save_data.inventory.clear()
	save_data.inventory.resize(save_data.inventory_size)
	save_data.available_warehouse_upgrades = 0
	save_data.upcoming_upgrade_costs = [1000, 2000]
	save_data.beat_game = false
	
	save_data.unlocked_warehouse = false
	save_data.unlocked_market = false
	save_data.unlocked_start_day = false
	
	# Global data
	save_data.current_day = 0
	
	# Order data
	save_data.available_quests.clear()
	save_data.previous_quests.clear()
	
	save_data.available_quests.append([initial_order, false, false, 0, 0, "???"])
	save_data.max_orders = 2
	save_data.generate_random_orders = false
	
	# Market trends
	Market.golden_trend.clear_trend()
	Market.amber_trend.clear_trend()
	Market.dark_trend.clear_trend()
	Market.verydark_trend.clear_trend()


func get_all_saves_arr():
	
	var dir = Directory.new()
	var save_data_arr:Array
	
	
	if dir.open(SAVE_FOLDER) == OK:
		dir.list_dir_begin()
		
		var filename = dir.get_next()
		while filename != "":
			if filename.begins_with("."):
				filename = dir.get_next()
				continue
			
			if dir.current_is_dir():
				filename = filename.plus_file(filename) + ".res"
				save_data_arr.append(ResourceLoader.load(SAVE_FOLDER.plus_file(filename)))
				
				filename = dir.get_next()
	
	return save_data_arr


# Handle saving the market trends
func save_market_trends():
	ResourceSaver.save(SAVE_FOLDER.plus_file(save_data.golden_trend_filename), Market.golden_trend)
	ResourceSaver.save(SAVE_FOLDER.plus_file(save_data.amber_trend_filename), Market.amber_trend)
	ResourceSaver.save(SAVE_FOLDER.plus_file(save_data.dark_trend_filename), Market.dark_trend)
	ResourceSaver.save(SAVE_FOLDER.plus_file(save_data.verydark_trend_filename), Market.verydark_trend)


func load_market_trends():
	if ResourceLoader.exists(SAVE_FOLDER.plus_file(save_data.golden_trend_filename)):
		Market.golden_trend = ResourceLoader.load(SAVE_FOLDER.plus_file(save_data.golden_trend_filename))
	if ResourceLoader.exists(SAVE_FOLDER.plus_file(save_data.amber_trend_filename)):
		Market.amber_trend = ResourceLoader.load(SAVE_FOLDER.plus_file(save_data.amber_trend_filename))
	if ResourceLoader.exists(SAVE_FOLDER.plus_file(save_data.dark_trend_filename)):
		Market.dark_trend = ResourceLoader.load(SAVE_FOLDER.plus_file(save_data.dark_trend_filename))
	if ResourceLoader.exists(SAVE_FOLDER.plus_file(save_data.verydark_trend_filename)):
		Market.verydark_trend = ResourceLoader.load(SAVE_FOLDER.plus_file(save_data.verydark_trend_filename))


func save_inv_to_savedata():
	save_data.inventory.resize(PlayerVariables.inventory_size)
	
	for i in PlayerVariables.inventory_size:
		if PlayerVariables.inventory[i] == null:
			save_data.inventory[i] = null
		else:
			var grade = PlayerVariables.inventory[i].grade
			var prod = PlayerVariables.inventory[i].producer
			var quality = PlayerVariables.inventory[i].quality
			var buy_price = PlayerVariables.inventory[i].buy_price
			var quantity = PlayerVariables.inventory[i].quantity
			
			var test = [grade, prod, quality, buy_price, quantity]
			
			save_data.inventory[i] = test


func load_inv_from_savedata():
	PlayerVariables.inventory.resize(save_data.inventory_size)
	
	for i in save_data.inventory_size:
		if save_data.inventory[i] == null:
			PlayerVariables.inventory[i] = null
		else:
			var grade = save_data.inventory[i][0]
			var prod = save_data.inventory[i][1]
			var quality = save_data.inventory[i][2]
			var buy_price = save_data.inventory[i][3]
			var quantity = save_data.inventory[i][4]
			
			PlayerVariables.inventory[i] = Item.new(grade, prod, quality, quantity)
			PlayerVariables.inventory[i].buy_price = buy_price


func save_orders_to_savedata():
	save_data.available_quests.clear()
	save_data.previous_quests.clear()
	
	for order_key in OrderFulfillment.available_quests:
		
		var accepted = OrderFulfillment.available_quests[order_key].accepted
		var overdue = OrderFulfillment.available_quests[order_key].overdue
		var days_since_init = OrderFulfillment.available_quests[order_key].days_since_init
		var days_since_accept = OrderFulfillment.available_quests[order_key].days_since_accept
		var distributer = OrderFulfillment.available_quests[order_key].distributer
		
		# 0: Key
		# 1: Accepted bool
		# 2: Overdue bool
		# 3: Days since inititalization
		# 4: Days since order accepted
		# 5: Distributer key
		var order = [order_key, accepted, overdue, days_since_init, days_since_accept, distributer]
		save_data.available_quests.append(order)
	
	# Previous quests is easier at the moment. The only data that needs to be stored is the keys
	for order_key in OrderFulfillment.previous_quests:
		save_data.previous_quests.append(order_key)


# This function is only ever called when loading a save
func load_orders_from_savedata():
	OrderFulfillment.available_quests.clear()
	OrderFulfillment.previous_quests.clear()
	
	for order in save_data.available_quests:
		
		var order_key = order[0]
		var accepted_bool = order[1]
		var overdue_bool = order[2]
		var days_since_init = order[3]
		var days_since_accept = order[4]
		var distributer = order[5]
		
		
		if OrderFulfillment.story_orders_dict.has(order_key):
			OrderFulfillment.available_quests[order_key] = OrderFulfillment.story_orders_dict[order_key]
		else:
			OrderFulfillment.available_quests[order_key] = OrderFulfillment.random_orders_dict[order_key]
		
		OrderFulfillment.available_quests[order_key].accepted = accepted_bool
		OrderFulfillment.available_quests[order_key].overdue = overdue_bool
		OrderFulfillment.available_quests[order_key].days_since_init = days_since_init
		OrderFulfillment.available_quests[order_key].days_since_accept = days_since_accept
		OrderFulfillment.available_quests[order_key].distributer = distributer
	
	for order_key in save_data.previous_quests:
		OrderFulfillment.previous_quests.append(order_key)


func save_producers_to_file(save:SaveData):
	# Producers directory path
	var save_dir = save.filename.split("/")[0]
	var path = SAVE_FOLDER.plus_file(save_dir).plus_file("Producers")
	
	for producer_abr in ShoppingController.producers_dict.keys():
		var res_path = path.plus_file(producer_abr + ".res")
		
		ResourceSaver.save(res_path, ShoppingController.producers_dict[producer_abr])


func load_producers_from_file(save:SaveData):
	# Producers directory path
	var save_dir = save.filename.split("/")[0]
	var path = SAVE_FOLDER.plus_file(save_dir).plus_file("Producers")
	
	var dir = Directory.new()
	
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var res_filename = dir.get_next()
		
		while res_filename != "":
			# load the file to resource
			if !dir.current_is_dir():
				var producer_file = Producer.new()
				producer_file = ResourceLoader.load(path.plus_file(res_filename))
				
				ShoppingController.producers_dict[producer_file.abr_name] = producer_file
				
			res_filename = dir.get_next()
	else:
		return


func save_options_to_file():
	ResourceSaver.save(OPTIONS_FILE, options)


func delete_save(save:SaveData):
	var dir = Directory.new()
	if dir.file_exists(SAVE_FOLDER.plus_file(save.filename)):
		# Delete the directory and file
		var split_arr = save.filename.split("/")
		
		# usr/saves/user_data_dir
		delete_files_in_dir(SAVE_FOLDER.plus_file(split_arr[0]))
		dir.remove(SAVE_FOLDER.plus_file(split_arr[0]))
	else:
		return


# Delete all files in a directory
func delete_files_in_dir(dir_name:String):
	
	var dir = Directory.new()
	
	if dir.open(dir_name) == OK:
		dir.list_dir_begin()
		var filename = dir.get_next()
		
		while filename != "":
			# Don't deal with the annoying stuff
			if filename.begins_with("."):
				filename = dir.get_next()
				continue
			
			if dir.current_is_dir():
				# Call this function recursively to delete files in the current dir
				delete_files_in_dir(dir_name.plus_file(filename))
			
			# Remove the current file
			dir.remove(dir_name.plus_file(filename))
			
			filename = dir.get_next()
