extends NinePatchRect

var accepted:bool = false
var order:Order

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_OrderSlot_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
				if event.pressed:
					OrderFulfillment.select_order_slot(self)

func accept_order():
	OrderFulfillment.refresh_order_panel_ui()

func add_information(new_order:Order = null):
	order = new_order
	
	$Subject/TitleLabel.text = order.title
	$From/DistributerLabel.text = order.distributer
