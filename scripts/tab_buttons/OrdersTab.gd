extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_OrdersTab_pressed():
	Global.switch_screen(Global.UI_PAGES.ORDERS)
