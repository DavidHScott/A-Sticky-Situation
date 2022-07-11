extends Timer

var minutes = 2
var seconds = 0

signal update_timer_ui(seconds, minutes)

# Called when the node enters the scene tree for the first time.
func _ready():
	ShoppingController.connect("start_shop_timer", self, "start_shop_timer")

func start_shop_timer():
	
	minutes = 1
	seconds = 0
	
	self.start()

func _on_ShopTimer_timeout():
	
	if minutes == 0 and seconds == 0:
		self.stop()
		Global._game().switch_game_state()
		return
	
	if seconds == 0:
		minutes -= 1
		seconds = 59
	else:
		seconds -= 1
	
	emit_signal("update_timer_ui", seconds, minutes)
