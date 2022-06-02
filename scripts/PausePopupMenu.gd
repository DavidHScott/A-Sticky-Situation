extends Popup

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_ResumeButton_pressed():
	get_tree().paused = false
	self.visible = false


func _on_OptionsButton_pressed():
	$OptionsMenu.visible = true


func _on_TitleButton_pressed():
	SaveAndLoad.save_current_game()
	
	get_tree().paused = false
	
	Global.exit_game()


func _on_QuitButton_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
