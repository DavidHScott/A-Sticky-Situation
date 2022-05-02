extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var fullscreen = SaveAndLoad.options.fullscreen
	
	$VBoxContainer/FullscreenOptionSelect.connect("option_changed", self, "fullscreen_option_changed")
	
	$VBoxContainer/FullscreenOptionSelect.current_option_index = int(fullscreen)
	$VBoxContainer/FullscreenOptionSelect.change_button_text($VBoxContainer/FullscreenOptionSelect.option_array[int(fullscreen)])


func fullscreen_option_changed(obj):
	SaveAndLoad.options.fullscreen = bool(obj.current_option_index)
	SaveAndLoad.save_options_to_file()
	
	OS.window_fullscreen = !OS.window_fullscreen
