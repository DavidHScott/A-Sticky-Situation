extends Button


func _on_BackToTitleScreen_pressed():
	AudioController.play_clip("button_click")
	Global.exit_game()


func _on_BackToTitleScreen_mouse_entered():
	AudioController.play_clip("menu_blip")
