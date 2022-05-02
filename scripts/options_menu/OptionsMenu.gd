extends Control


const audio_page = preload("res://scenes/options_menu/AudioOptionsPage.tscn")
const video_page = preload("res://scenes/options_menu/VideoOptionsPage.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	for obj in $MarginContainer/OptionsMargin/HBoxContainer/OptionCategories.get_children():
		obj.connect("pressed", self, "open_options_page", [obj])
	
	for obj in $MarginContainer/OptionsMargin/HBoxContainer/OptionCategories.get_children():
		obj.connect("mouse_entered", self, "play_blip")
	
	pass # Replace with function body.


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
	
	if $MarginContainer/OptionsMargin/HBoxContainer/OptionsContainer.get_child(0) != null:
		$MarginContainer/OptionsMargin/HBoxContainer/OptionsContainer.get_child(0).queue_free()
	
	$MarginContainer/OptionsMargin/HBoxContainer/OptionsContainer.add_child(option_page)


func play_blip():
	AudioController.play_clip("menu_blip")
