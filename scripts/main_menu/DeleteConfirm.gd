extends Popup

var selected_save

signal delete_confirmed()

func _on_LoadGameMenu_open_popup(save):
	# Keep reference to save just in case I want to add text to popup
	popup_centered()
	selected_save = save


func _on_ConfirmButton_pressed():
	emit_signal("delete_confirmed")
	
	self.visible = false


func _on_CancelButton_pressed():
	self.visible = false
