extends NinePatchRect

var item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_item(item):
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
				if event.pressed:
					ShoppingController.slot_selected(item)
