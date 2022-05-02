extends Button


func _on_BackToTitleScreen_pressed():
	AudioController.play_clip("button_click")
	get_tree().change_scene("res://scenes/main_menu/MainMenu.tscn")


func _on_BackToTitleScreen_mouse_entered():
	AudioController.play_clip("menu_blip")
