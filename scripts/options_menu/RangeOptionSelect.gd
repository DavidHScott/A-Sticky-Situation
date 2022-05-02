extends HBoxContainer


func _on_OptionRange_value_changed(value):
	$OptionRange/Label.text = str(value) + "%"
