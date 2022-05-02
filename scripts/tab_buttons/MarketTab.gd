extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_MarketTab_pressed():
	Global._game().switch_screen(Global._game().UI_PAGES.MARKET)
