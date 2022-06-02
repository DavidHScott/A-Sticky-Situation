extends Button


func _on_BackToTitleScreen_pressed():
	AudioController.play_clip("button_click")
	self.get_parent().get_parent().visible = false


func _on_BackToTitleScreen_mouse_entered():
	AudioController.play_clip("menu_blip")
