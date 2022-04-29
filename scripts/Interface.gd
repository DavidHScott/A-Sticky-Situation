extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Global._game().connect("open_new_page", self, "open_page")
	Global._game().connect("game_state_switch", self, "refresh_ui")
	
	refresh_ui()

func open_page(ref_to_new_scene):
	var scene = ref_to_new_scene.instance()
	$Page.add_child(scene)

func refresh_ui():
	$LowerThird/WarehouseTab.visible = true
	$LowerThird/OrdersTab.visible = true
	$LowerThird/MarketTab.visible = true
	
	if Global.current_game_state == Global.GAME_STATE.DOWNTIME:
		$LowerThird/StartDayTab.visible = true
		$LowerThird/BuySyrupTab.visible = false
		$LowerThird/TimerPanel.visible = false
	else:
		$LowerThird/StartDayTab.visible = false
		$LowerThird/BuySyrupTab.visible = true
		$LowerThird/TimerPanel.visible = true


func _on_PauseButton_pressed():
	
	pass # Replace with function body.
