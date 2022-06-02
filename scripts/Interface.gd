extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Global._game().connect("open_new_page", self, "open_page")
	Global._game().connect("game_state_switch", self, "refresh_ui")


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


func pause_game():
	$PausePopupMenu.visible = true
	get_tree().paused = true


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		pause_game()
