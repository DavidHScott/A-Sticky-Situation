extends Node

var initial_money = 5000
var initial_inventory_size = 8
var initial_order = "???_0"

const SAVE_FOLDER = "user://saves"
const USER_DATA = "user://user_data.json"
const SAVE_DIR_TEMPLATE = "%s_userdata%s"
const SAVE_NAME_TEMPLATE = "%s_userdata%s.res"

const OPTIONS_FILE = "user://options.res"

var save_data = SaveData.new()
var options = Options.new()

func _ready():
	var info_file = File.new()
	if !info_file.file_exists(USER_DATA):
		first_time_setup()
	
	if ResourceLoader.exists(OPTIONS_FILE):
		options = ResourceLoader.load(OPTIONS_FILE)
	
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
		
		filename = directoryname.plus_file(SAVE_NAME_TEMPLATE % [username, "_" + str(id)])
	else:
		directoryname = SAVE_DIR_TEMPLATE % [username, ""]
		directory.make_dir(SAVE_FOLDER.plus_file(directoryname))
		
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
	
	# Update the save map
	inc_num_saves(1)
	add_save_to_arr(filename)
	
	return save_data


func load_save(filename):
	if ResourceLoader.exists(SAVE_FOLDER.plus_file(filename)):
		save_data = ResourceLoader.load(SAVE_FOLDER.plus_file(filename))
		load_inv_from_savedata()
		
		return save_data


func save_current_game():
	# Keep the inventory up to date
	save_inv_to_savedata()
	
	var modified_date = OS.get_datetime()
	save_data.last_modified["Day"] = modified_date["day"]
	save_data.last_modified["Month"] = modified_date["month"]
	save_data.last_modified["Year"] = modified_date["year"]
	
	ResourceSaver.save(SAVE_FOLDER.plus_file(save_data.filename), save_data)


func get_num_saves():
	var file = File.new()
	file.open(USER_DATA, File.READ)
	var json = JSON.parse(file.get_as_text())
	var data = json.result
	file.close()
	
	return str(data["NumberOfSaves"])


func inc_num_saves(i):
	var file = File.new()
	file.open(USER_DATA, File.READ_WRITE)
	
	var json = JSON.parse(file.get_as_text())
	var data = json.result
	data["NumberOfSaves"] += i
	
	file.store_string(to_json(data))
	file.close()


func add_save_to_arr(filename:String):
	var file = File.new()
	file.open(USER_DATA, File.READ_WRITE)
	
	var json = JSON.parse(file.get_as_text())
	var data = json.result
	
	data["SaveNames"].append(filename)
	
	file.store_string(to_json(data))
	
	file.close()


# Clear the save game to the default new game settings
func clear_save_game():
	save_data.save_data_version = Global.current_game_version
	save_data.filename = ""
	
	# Player data
	save_data.player_name = ""
	save_data.money = initial_money
	save_data.inventory_size = initial_inventory_size
	save_data.inventory.clear()
	save_data.inventory.resize(save_data.inventory_size)
	
	# Global data
	save_data.current_day = 0
	
	# Order data
	save_data.previous_quest_keys.clear()
	save_data.available_quest_keys.clear()
	
	save_data.available_quest_keys[initial_order] = false
	save_data.max_orders = 2
	save_data.generate_random_orders = false
	
	# Market trends
	Market.golden_trend.clear_trend()
	Market.amber_trend.clear_trend()
	Market.dark_trend.clear_trend()
	Market.verydark_trend.clear_trend()


func first_time_setup():
	var boilerplate = {
		"NumberOfSaves": 0,
		"SaveNames": [
			
		]
	}
	
	# Set up the directory for save data
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir("saves")
	
	var file = File.new()
	file.open(USER_DATA, File.WRITE)
	file.store_string(to_json(boilerplate))
	file.close()
	
	ResourceSaver.save(OPTIONS_FILE, options)


func get_all_saves_arr():
	var file = File.new()
	file.open(USER_DATA, File.READ)
	var json = JSON.parse(file.get_as_text())
	var data = json.result
	file.close()
	
	var filename_arr = data["SaveNames"]
	var save_data_arr:Array
	
	for filename in filename_arr:
		if ResourceLoader.exists(SAVE_FOLDER.plus_file(filename)):
			save_data_arr.append(ResourceLoader.load(SAVE_FOLDER.plus_file(filename)))
	
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


func save_options_to_file():
	ResourceSaver.save(OPTIONS_FILE, options)


func delete_save(save:SaveData):
	var dir = Directory.new()
	if dir.file_exists(SAVE_FOLDER.plus_file(save.filename)):
		# Delete the directory and file
		var split_arr = save.filename.split("/")
		
		dir.remove(SAVE_FOLDER.plus_file(save.filename))
		dir.remove(SAVE_FOLDER.plus_file(split_arr[0]))
	else:
		return
	
	# remove it from the user_data.json file
	var file = File.new()
	file.open(USER_DATA, File.READ_WRITE)
	var json = JSON.parse(file.get_as_text())
	var data = json.result
	
	data["SaveNames"].erase(save.filename)
	data["NumberOfSaves"] -= 1
	
	file.close()
	
	dir.remove(USER_DATA)
	
	file.open(USER_DATA, file.WRITE)
	file.store_string(to_json(data))
	file.close()
