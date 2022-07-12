extends Node2D


var current_game_version = "0.1"

var currently_in_game = false

signal slot_select(item)
signal clear_info_panel()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_auto_accept_quit(false)


func _game():
	if get_tree().get_root().has_node("Game"):
		return get_tree().get_root().get_node("Game")


func start_game():
	
	currently_in_game = true
	
	# First, load the scene
	get_tree().change_scene("res://scenes/gameplay/Game.tscn")
	
#	for order in SaveAndLoad.save_data.available_quests:
#		var key = order[0]
#
#		if OrderFulfillment.story_orders_dict.has(key):
#			OrderFulfillment.available_quests[key] = OrderFulfillment.story_orders_dict[key]
#		elif OrderFulfillment.random_orders_dict.has(key):
#			OrderFulfillment.available_quests[key] = OrderFulfillment.random_orders_dict[key]
#
#		OrderFulfillment.available_quests[key].accepted = SaveAndLoad.save_data.available_quests[key]
	
	SaveAndLoad.load_orders_from_savedata()
	SaveAndLoad.load_market_trends()


func exit_game():
	# Might add a loading screen or animation or something
	
	get_tree().change_scene("res://scenes/main_menu/MainMenu.tscn")

#### Handle notifications
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		
		if currently_in_game:
			SaveAndLoad.save_current_game()
		
		get_tree().quit()

