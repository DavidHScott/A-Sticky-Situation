extends Node2D


var current_game_version = "0.1"

signal slot_select(item)
signal clear_info_panel()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_auto_accept_quit(false)


func _game():
	if get_tree().get_root().has_node("Game"):
		return get_tree().get_root().get_node("Game")


func start_game():
	# load the selected save data into the right spots
	
	PlayerVariables.name = SaveAndLoad.save_data.player_name
	PlayerVariables.money = SaveAndLoad.save_data.money
	PlayerVariables.inventory_size = SaveAndLoad.save_data.inventory_size
	
	SaveAndLoad.load_inv_from_savedata()
	
	_game().current_day = SaveAndLoad.save_data.current_day
	
	for key in SaveAndLoad.save_data.available_quest_keys:
		if OrderFulfillment.story_orders_dict.has(key):
			OrderFulfillment.available_quests[key] = OrderFulfillment.story_orders_dict[key]
		elif OrderFulfillment.random_orders_dict.has(key):
			OrderFulfillment.available_quests[key] = OrderFulfillment.random_orders_dict[key]
		
		OrderFulfillment.available_quests[key].accepted = SaveAndLoad.save_data.available_quest_keys[key]
	
	SaveAndLoad.load_market_trends()
	
	# Finally, load the scene
	get_tree().change_scene("res://scenes/gameplay/Game.tscn")


#### Handle notifications
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		# TODO: Make sure to save the game here!!
		get_tree().quit()

