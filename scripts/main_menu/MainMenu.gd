extends Control


func _ready():
	# Set the version number correctly
	$AspectRatioContainer/VBoxContainer/VersionLabel.text = "Version: " + Global.current_game_version
	
	for button in $AspectRatioContainer/VBoxContainer/MarginContainer/Menu.get_children():
		button.connect("pressed", self, "_on_menu_button_pressed", [button.selected_button_type, button.scene_path_to_load])


func quit_game():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func load_scene(scene_to_load):
	get_tree().change_scene(scene_to_load)


func _on_menu_button_pressed(button_type, scene_to_load):
	AudioController.play_clip("button_click")
	
	if button_type == 0:
		load_scene(scene_to_load)
	elif button_type == 1:
		quit_game()
