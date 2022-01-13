extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("close_current_page", self, "close_page")
	Global.connect("game_state_switch", self, "refresh_ui")
	
	refresh_ui()

func refresh_ui():
	if Global.current_game_state == Global.GAME_STATE.DOWNTIME:
		$SellAllButton.visible = false
		$SellOneButton.visible = false
	else:
		$SellAllButton.visible = true
		$SellOneButton.visible = true

func close_page():
	queue_free()
