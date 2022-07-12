extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Global._game().connect("open_new_page", self, "open_page")
	Global._game().connect("game_state_switch", self, "refresh_ui")
	$PausePopupMenu/MainPauseMenu/VBoxContainer/ResumeButton.connect("pressed", self, "unpause_game")
	
	# Update the escape stack
	Global._game().esc_button_stack.append([self, "pause_game"])


func open_page(ref_to_new_scene):
	var scene = ref_to_new_scene.instance()
	$Page.add_child(scene)


func refresh_ui():
	
	if Global._game().current_game_state == Global._game().GAME_STATE.DOWNTIME:
		$LowerThird/StartDayTab.visible = true
		$LowerThird/Right/BuySyrupTab.visible = false
		$LowerThird/TimerPanel.visible = false
	else:
		$LowerThird/StartDayTab.visible = false
		$LowerThird/Right/BuySyrupTab.visible = true
		$LowerThird/TimerPanel.visible = true


func _on_PauseButton_pressed():
	pause_game()


func unpause_game():
	get_tree().paused = false
	$PausePopupMenu.visible = false
	
	Global._game().esc_button_stack.pop_back()


func pause_game():
	Global._game().esc_button_stack.append([self, "unpause_game"])
	
	$PausePopupMenu.visible = true
	get_tree().paused = true


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		var obj = Global._game().esc_button_stack.back()[0]
		var function = Global._game().esc_button_stack.back()[1]
		
		obj.call(function)
