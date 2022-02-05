extends NinePatchRect

var required_item_scene = preload("res://scenes/gui_components/page_panels/OrderFulfillment/RequiredItem.tscn")

var selected_order_slot:Control = null
var selected_order:Order = null

signal open_popup(order, item_arr)

# Called when the node enters the scene tree for the first time.
func _ready():
	OrderFulfillment.connect("order_slot_select", self, "render_selected_order")
	OrderFulfillment.connect("remove_order", self, "remove_selected_order")
	
	# Deactivate all the buttons until something gets selected
	$FulfillButton.visible = false
	$AcceptButton.visible = false
	
	# Clear the panel
	clear_panel()

func clear_panel():
	# Remove the requirements. They're added programmatically
	for node in $ScrollGrid/ItemInformation/Requirements.get_children():
		$ScrollGrid/ItemInformation/Requirements.remove_child(node)
		node.queue_free()
	
	# The rest can just be disabled
	$ScrollGrid/ItemInformation.visible = false

func render_selected_order(order_slot):
	selected_order_slot = order_slot
	selected_order = order_slot.order
	
	# Clear the panel
	clear_panel()
	$ScrollGrid/ItemInformation.visible = true
	
	# Title
	$ScrollGrid/ItemInformation/SubjectLabel.text = selected_order.title
	$ScrollGrid/ItemInformation/From/DistributerName.text = selected_order.distributer
	
	# Description
	$ScrollGrid/ItemInformation/OrderDescription.text = selected_order.job_description
	
	# Requirements
	for item in selected_order.requirements:
		var required_item = required_item_scene.instance()
		required_item.edit_text(item)
		
		$ScrollGrid/ItemInformation/Requirements.add_child(required_item)
	
	# Deadline
	if selected_order.fulfill_timelimit > 0:
		
		$ScrollGrid/ItemInformation/Deadline/Timelimit.text = str(selected_order.fulfill_timelimit) + " Days"
	else:
		$ScrollGrid/ItemInformation/Deadline/Timelimit.text = "None"
	
	# Pay
	$ScrollGrid/ItemInformation/Pay.text = "$" + str(selected_order.pay)
	
	# Render the buttons
	render_buttons()
	
	# Check if the order is accepted + can be fulfilled
	# Enable/disable fulfill button

func render_buttons():
	if selected_order == null:
		$FulfillButton.visible = false
		$AcceptButton.visible = false
		return
	
	if selected_order.accepted:
		$AcceptButton.visible = false
		
		$FulfillButton.visible = true
		
		if OrderFulfillment.can_be_fulfilled(selected_order) == null: 
			$FulfillButton.disabled = true
		else:
			$FulfillButton.disabled = false
	else:
		$FulfillButton.visible = false
		
		$AcceptButton.visible = true

## Buttons
func _on_FulfillButton_pressed():
	var item_arr = OrderFulfillment.can_be_fulfilled(selected_order)
	
	emit_signal("open_popup", selected_order, item_arr)

func _on_AcceptButton_pressed():
	# Set the order to accepted & put the slot into the acceptedOrders container
	selected_order.accept_order()
	selected_order_slot.accept_order()
	
	# Render buttons
	render_buttons()

func remove_selected_order():
	clear_panel()
	
	selected_order_slot = null
	selected_order = null
	
	render_buttons()
