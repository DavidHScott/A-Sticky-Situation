extends NinePatchRect

var accepted:bool = false
var order_key:String
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

func add_information(new_order_key:String):
	order_key = new_order_key
	order = OrderFulfillment.available_quests[order_key]
	
	$Subject/TitleLabel.text = order.title
	$From/DistributerLabel.text = order.distributer
