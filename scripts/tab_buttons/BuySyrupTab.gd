extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_BuySyrupTab_pressed():
	Global.switch_screen(Global.UI_PAGES.BUY_SYRUP)
