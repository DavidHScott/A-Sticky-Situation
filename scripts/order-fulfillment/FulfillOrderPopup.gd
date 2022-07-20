extends Popup

var selected_order_key:String
var item_array:Array

var shipped_items_ui
var popup_ship_item_scene = preload("res://scenes/gui_components/page_panels/OrderFulfillment/PopupShipItem.tscn")

func _ready():	
	shipped_items_ui = $NinePatchRect/ScrollContainer/PopupLayout/ShippedItems

func populate(order_key:String, item_arr:Array):
	Global._game().esc_button_stack.append([self, "_on_CancelButton_pressed"])
	
	# Clear the to be shipped item sections
	for node in shipped_items_ui.get_children():
		shipped_items_ui.remove_child(node)
		node.queue_free()
	
	item_array = item_arr
	selected_order_key = order_key
	var selected_order = OrderFulfillment.available_quests[selected_order_key]
	
	for item in item_array:
		var new_scene = popup_ship_item_scene.instance()
		new_scene.populate_data(item)
		
		shipped_items_ui.add_child(new_scene)
	
	$NinePatchRect/ScrollContainer/PopupLayout/PaymentLabel.text = "$" + str(selected_order.pay)
	
	self.rect_min_size = Vector2(0, $NinePatchRect/ScrollContainer/PopupLayout.rect_size.y)

func _on_ConfirmButton_pressed():
	OrderFulfillment.fulfill_order(selected_order_key, item_array)
	Global._game().esc_button_stack.pop_back()
	
	self.visible = false


func _on_CancelButton_pressed():
	Global._game().esc_button_stack.pop_back()
	self.visible = false


func _on_OrderInformationPanel_open_popup(order, item_arr):
	popup_centered()
	populate(order, item_arr)
