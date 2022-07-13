extends NinePatchRect

var required_item_scene = preload("res://scenes/gui_components/page_panels/OrderFulfillment/RequiredItem.tscn")

var selected_order_slot:Control = null
var selected_order_key:String
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
	selected_order_key = order_slot.order_key
	selected_order = order_slot.order
	
	# Clear the panel
	clear_panel()
	$ScrollGrid/ItemInformation.visible = true
	
	# Title
	$ScrollGrid/ItemInformation/SubjectLabel.text = selected_order.title
	$ScrollGrid/ItemInformation/From/DistributerName.text = selected_order.distributer
	
	# Description
	# Make format the text first
	var desc = format_text(selected_order.job_description)
	$ScrollGrid/ItemInformation/OrderDescription.text = desc
	
	# Requirements
	if selected_order.requirements != null:
		$ScrollGrid/ItemInformation/Separator2.visible = true
		$ScrollGrid/ItemInformation/Requirements.visible = true
		$ScrollGrid/ItemInformation/Separator3.visible = true
		$ScrollGrid/ItemInformation/Deadline.visible = true
		$ScrollGrid/ItemInformation/Pay.visible = true
		
		for item in selected_order.requirements:
			var required_item = required_item_scene.instance()
			required_item.edit_text(item)
			
			$ScrollGrid/ItemInformation/Requirements.add_child(required_item)
		
		# Deadline
		if selected_order.fulfill_timelimit > 0:
			$ScrollGrid/ItemInformation/Deadline/Timelimit.text = str(selected_order.fulfill_timelimit - selected_order.days_since_accept) + " Days"
			
			if selected_order.fulfill_timelimit - selected_order.days_since_accept < 0:
				$ScrollGrid/ItemInformation/Deadline/Timelimit.text = "OVERDUE"
		else:
			$ScrollGrid/ItemInformation/Deadline/Timelimit.text = "None"
		
		# Pay
		if !selected_order.overdue:
			$ScrollGrid/ItemInformation/Pay.bbcode_text = "[center]$" + str(selected_order.pay) + "[/center]"
		else:
			# Is there a way to override the strikethrough to make it more than one pixel?
			$ScrollGrid/ItemInformation/Pay.bbcode_text = "[center][s][color=#a63700]$" + str(selected_order.pay) + "[/color][/s] $" + str(selected_order.overdue_pay) + "[/center]"
	else:
		$ScrollGrid/ItemInformation/Separator2.visible = false
		$ScrollGrid/ItemInformation/Requirements.visible = false
		$ScrollGrid/ItemInformation/Separator3.visible = false
		$ScrollGrid/ItemInformation/Deadline.visible = false
		$ScrollGrid/ItemInformation/Pay.visible = false
	
	# Render the buttons
	render_buttons()

func render_buttons():
	if selected_order == null:
		$FulfillButton.visible = false
		$AcceptButton.visible = false
		return
	
	if selected_order.accepted:
		$AcceptButton.visible = false
		
		$FulfillButton.visible = true
		
		if OrderFulfillment.can_be_fulfilled(selected_order_key) == null: 
			$FulfillButton.disabled = true
		else:
			$FulfillButton.disabled = false
	else:
		$FulfillButton.visible = false
		
		$AcceptButton.visible = true

## Buttons
func _on_FulfillButton_pressed():
	var item_arr = OrderFulfillment.can_be_fulfilled(selected_order_key)
	emit_signal("open_popup", selected_order_key, item_arr)

func _on_AcceptButton_pressed():
	
	# Set the order to accepted & put the slot into the acceptedOrders container
	selected_order.accept_order()
	selected_order_slot.accept_order()
	
	OrderFulfillment.order_accepted(selected_order_key)
	
	if selected_order.requirements == null:
		OrderFulfillment.fulfill_order(selected_order_key, null)
		remove_selected_order()
	
	# Save the change
	SaveAndLoad.save_orders_to_savedata()
	
	# Render buttons
	render_buttons()

func remove_selected_order():
	clear_panel()
	
	selected_order_slot = null
	selected_order = null
	
	render_buttons()


func format_text(text:String) -> String:
	text = text.format({"playername": PlayerVariables.username})
	
	var regex = RegEx.new()
	regex.compile("\\{producer-[a-zA-Z]+\\}")
	
	var result = regex.search_all(text)
	
	for r in result:
		# "r" is the item that will be used for text replacement
		var abr_name = r.get_string().substr(10, 3)
		var placeholder = r.get_string()
		placeholder.erase(0, 1)
		placeholder.erase(placeholder.length() - 1, 1)
		
		print(placeholder)
		
		# If there is a producer that matches the abbreviated name, then replace the string
		if ShoppingController.producers_dict.has(abr_name):
			text = text.format({placeholder: ShoppingController.producers_dict[abr_name].full_name})
			pass
		else:
			continue
	
	return text
