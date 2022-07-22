extends Control


func _ready():
	
	# Set the version number correctly
	$AspectRatioContainer/VBoxContainer/VersionLabel.text = "Version: " + Global.current_game_version
	
	for button in $AspectRatioContainer/VBoxContainer/MarginContainer/Menu.get_children():
		button.connect("pressed", self, "_on_menu_button_pressed", [button.selected_button_type, button.scene_path_to_load])
	
	if Global.startup:
		$CRTShaderThing.visible = true
		Global.startup = false
		
		$CRTShaderThing/AnimationPlayer.play("post_splash_screen")
		
		yield($CRTShaderThing/AnimationPlayer, "animation_finished")
		$CRTShaderThing.visible = false
	else:
		$CRTShaderThing.visible = false
	
	if Global.should_fade_to_main:
		$SceneTransitionPanel.visible = true
		
		$SceneTransitionPanel/AnimationPlayer.play("transition_to_screen")
		Global.should_fade_to_main = false
		yield($SceneTransitionPanel/AnimationPlayer, "animation_finished")
		$SceneTransitionPanel.visible = false
	else:
		$SceneTransitionPanel.visible = false
	
	Global.should_fade_to_main = true


func quit_game():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func load_scene(scene_to_load):
	get_tree().change_scene(scene_to_load)


func _on_menu_button_pressed(button_type, scene_to_load):
	AudioController.play_clip("button_click")
	
	$SceneTransitionPanel.visible = true
	$SceneTransitionPanel/AnimationPlayer.play("transition_to_black")
	yield($SceneTransitionPanel/AnimationPlayer, "animation_finished")
	
	
	if button_type == 0:
		load_scene(scene_to_load)
	elif button_type == 1:
		quit_game()
