extends Popup


func _on_ResumeButton_pressed():
	#get_tree().paused = false
	#self.visible = false
	pass


func _on_OptionsButton_pressed():
	$OptionsMenu.visible = true


func _on_TitleButton_pressed():
	Global._game().exit_game()


func _on_QuitButton_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
