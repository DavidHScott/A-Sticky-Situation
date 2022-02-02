extends NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready():
	OrderFulfillment.connect("order_slot_select", self, "render_selected_order")
	
	# Deactivate all the buttons until something gets selected
	$FulfillButton.visible = false
	$CancelButton.visible = false
	$AcceptButton.visible = false

func render_selected_order(order_slot):
	pass
