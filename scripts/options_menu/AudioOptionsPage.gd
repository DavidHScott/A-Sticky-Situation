extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	# get the options to set the selectors
	var n = SaveAndLoad.options.master_volume * 100
	$VBoxContainer/MasterVolumeSelect/OptionRange.value = n
	
	n = SaveAndLoad.options.music_volume * 100
	$VBoxContainer/MusicVolumeSelect/OptionRange.value = n
	
	n = SaveAndLoad.options.sfx_volume * 100
	$VBoxContainer/EffectsVolumeSelect/OptionRange.value = n


func _on_MasterVolumeRange_value_changed(value):
	SaveAndLoad.options.master_volume = value / 100
	SaveAndLoad.save_options_to_file()
	
	AudioController.change_master_volume(value / 100)


func _on_MusicVolumeRange_value_changed(value):
	SaveAndLoad.options.music_volume = value / 100
	SaveAndLoad.save_options_to_file()
	
	AudioController.change_music_volume(value / 100)


func _on_EffectsVolumeRange_value_changed(value):
	SaveAndLoad.options.sfx_volume = value / 100
	SaveAndLoad.save_options_to_file()
	
	AudioController.change_effects_volume(value / 100)
