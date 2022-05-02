extends HBoxContainer

export var option_array = []

var current_option_index = 0

signal option_changed(obj)

func _on_OptionButton_pressed():
	current_option_index += 1
	
	if current_option_index >= option_array.size():
		current_option_index = 0
	
	change_button_text(option_array[current_option_index])
	
	emit_signal("option_changed", self)

func change_button_text(text):
	$OptionButton/Label.text = text
