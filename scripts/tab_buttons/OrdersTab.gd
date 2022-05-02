extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_OrdersTab_pressed():
	Global._game().switch_screen(Global._game().UI_PAGES.ORDERS)
