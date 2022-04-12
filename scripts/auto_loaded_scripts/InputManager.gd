extends Node

enum GAME_MENU {
	TITLE_SCREEN,
	NEW_GAME,
	LOAD_GAME,
	OPTIONS,
	GAMEPLAY
}


var current_game_menu = GAME_MENU.TITLE_SCREEN

var current_focus:Node2D = null

# Determines the input scheme. If true, the player is using their keyboard or gamepad.
# 	If false, the player is using their mouse
var button_input = false

# Handle Inputs
func _input(event):
	if event.is_action_pressed(""):
		pass
	
	if event is InputEventMouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
