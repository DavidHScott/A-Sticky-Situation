extends Control


func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(str(meta))


func _on_ReturnToTitle_pressed():
	AudioController.play_clip("button_click")
	Global._game().exit_game()
