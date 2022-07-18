extends Control


func _on_LineEdit_text_changed(new_text):
	# If the textbox isn't empty, enable the button
	if $MarginContainer/EnterUsername/VBoxContainer/LineEdit.text == "":
		$MarginContainer/EnterUsername/VBoxContainer/Button.disabled = true
	else:
		$MarginContainer/EnterUsername/VBoxContainer/Button.disabled = false


func _on_Button_pressed():
	# Get the username, create a new save file, and start the game
	var username = $MarginContainer/EnterUsername/VBoxContainer/LineEdit.text
	
	var save_file = SaveAndLoad.create_new_save(username)
	
	$FadePanel.visible = true
	$FadePanel/AnimationPlayer.play("fade_to_black")
	yield($FadePanel/AnimationPlayer, "animation_finished")
	
	Global.start_game()
