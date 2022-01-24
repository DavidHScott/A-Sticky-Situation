extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("close_current_page", self, "close_page")
	Global.connect("game_state_switch", self, "refresh_page")

func close_page():
	queue_free()

func refresh_page():
	$MarketPanel/MarketGraphic.update()
