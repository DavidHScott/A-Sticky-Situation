extends NinePatchRect


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				Market.change_timeline_view()


func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			$FocusCursor.visible = true
			
			# TODO: When the GUI focus system is implemented, make this change the current focus
		NOTIFICATION_MOUSE_EXIT:
			$FocusCursor.visible = false
