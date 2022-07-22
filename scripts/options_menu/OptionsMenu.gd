extends Control


const audio_page = preload("res://scenes/options_menu/AudioOptionsPage.tscn")
const video_page = preload("res://scenes/options_menu/VideoOptionsPage.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for obj in $MarginContainer/OptionsMargin/HBoxContainer/OptionCategories.get_children():
		obj.connect("pressed", self, "open_options_page", [obj])
	
	for obj in $MarginContainer/OptionsMargin/HBoxContainer/OptionCategories.get_children():
		obj.connect("mouse_entered", self, "play_blip")
	
	
	if Global._game() == null:
		$MarginContainer/BackToTitleScreen.connect("pressed", self, "exiting_scene")
		
		$SceneTransitionPanel.visible = true
		$SceneTransitionPanel/AnimationPlayer.play("transition_to_screen")
		yield($SceneTransitionPanel/AnimationPlayer, "animation_finished")
		$SceneTransitionPanel.visible = false
	else:
		$MarginContainer/BackToPauseScreen.connect("pressed", self, "back_to_pause")


func open_options_page(source):
	AudioController.play_clip("button_click")
	
	for obj in $MarginContainer/OptionsMargin/HBoxContainer/OptionCategories.get_children():
		obj.pressed = false
	
	source.pressed = true
	
	var option_page
	
	match source.option_page:
		source.page_enum.AUDIO:
			option_page = audio_page.instance()
		source.page_enum.VIDEO:
			option_page = video_page.instance()
	
	if $MarginContainer/OptionsMargin/HBoxContainer/OptionsContainer/NinePatchRect.get_child(0) != null:
		$MarginContainer/OptionsMargin/HBoxContainer/OptionsContainer/NinePatchRect.get_child(0).queue_free()
	
	$MarginContainer/OptionsMargin/HBoxContainer/OptionsContainer/NinePatchRect.add_child(option_page)


func play_blip():
	AudioController.play_clip("menu_blip")


func exiting_scene():
	$SceneTransitionPanel.visible = true
	$SceneTransitionPanel/AnimationPlayer.play("transition_to_black")
	yield($SceneTransitionPanel/AnimationPlayer, "animation_finished")
	
	get_tree().change_scene("res://scenes/main_menu/MainMenu.tscn")


func back_to_pause():
	self.visible = false
	pass
