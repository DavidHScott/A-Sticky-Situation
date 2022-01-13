extends NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShopTimer.connect("update_timer_ui", self, "update_ui")

func update_ui(seconds, minutes):
	
	var str_seconds = str(seconds)
	
	if(seconds < 10):
		str_seconds = "0" + str(seconds)
	
	$Label.text = str(minutes) + ":" + str_seconds
