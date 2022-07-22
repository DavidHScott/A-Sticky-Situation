extends Button


func _on_BackToTitleScreen_pressed():
	AudioController.play_clip("button_click")
	AudioController.play_clip("button_click")

func _on_BackToTitleScreen_mouse_entered():
	AudioController.play_clip("menu_blip")
