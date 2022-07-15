extends NinePatchRect

var order_slot = preload("res://scenes/gui_components/slots/OrderSlot.tscn")

var selected_slot = null

# Called when the node enters the scene tree for the first time.
func _ready():
	OrderFulfillment.connect("refresh_order_panel", self, "refresh_ui")
	OrderFulfillment.connect("order_fulfilled", self, "remove_slot")
	OrderFulfillment.connect("order_slot_select", self, "order_slot_select")
	OrderFulfillment.connect("order_accepted", self, "accept_order")
	# TODO
	OrderFulfillment.connect("remove_order", self, "remove_selected_order")
	
	refresh_ui()


func refresh_ui():
	clear_panel()
	
	# Get quests from the OrderFulfillment script and populate the menu
	for item_key in OrderFulfillment.available_quests.keys():
		var slot = order_slot.instance()
		slot.add_information(item_key)
		
		if item_key in OrderFulfillment.order_purgatory:
			continue
		
		if OrderFulfillment.available_quests[item_key].accepted:
			$ScrollContainer/VBoxContainer/AcceptedOrders.add_child(slot)
		else:
			$ScrollContainer/VBoxContainer/NewOrders.add_child(slot)
	
	if $ScrollContainer/VBoxContainer/AcceptedOrders.get_child_count() == 1:
		$ScrollContainer/VBoxContainer/AcceptedOrders/AcceptedLabel.visible = false
	else:
		$ScrollContainer/VBoxContainer/AcceptedOrders/AcceptedLabel.visible = true
	
	if $ScrollContainer/VBoxContainer/NewOrders.get_child_count() == 1:
		$ScrollContainer/VBoxContainer/NewOrders/NewLabel.visible = false
	else:
		$ScrollContainer/VBoxContainer/NewOrders/NewLabel.visible = true


func clear_panel():
	for node in $ScrollContainer/VBoxContainer/AcceptedOrders.get_children():
		if node.get_index() > 0:
			$ScrollContainer/VBoxContainer/AcceptedOrders.remove_child(node)
			node.queue_free()
	
	for node in $ScrollContainer/VBoxContainer/NewOrders.get_children():
		if node.get_index() > 0:
			$ScrollContainer/VBoxContainer/NewOrders.remove_child(node)
			node.queue_free()


func accept_order(order_slot):
	$ScrollContainer/VBoxContainer/NewOrders.remove_child(order_slot)
	$ScrollContainer/VBoxContainer/AcceptedOrders.add_child(order_slot)
	
	$ScrollContainer/VBoxContainer/AcceptedOrders/AcceptedLabel.visible = true
	
	if $ScrollContainer/VBoxContainer/NewOrders.get_child_count() == 1:
		$ScrollContainer/VBoxContainer/NewOrders/NewLabel.visible = false


func order_slot_select(slot):
	selected_slot = slot


func remove_selected_order():
	selected_slot.slide_out()
	selected_slot = null
