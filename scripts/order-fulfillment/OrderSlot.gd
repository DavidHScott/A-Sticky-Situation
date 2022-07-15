extends Control

var accepted:bool = false
var order_key:String
var order:Order

var selected:bool = false setget set_select

onready var tween = get_node("Control/Tween")


func set_select(b):
	selected = b
	$FocusCursor.visible = b


# Called when the node enters the scene tree for the first time.
func _ready():	
	if order.shown_in_order_page == false:
		slide_in()


func add_information(new_order_key:String):
	order_key = new_order_key
	order = OrderFulfillment.available_quests[new_order_key]
	
	$Control/Subject/TitleLabel.text = order.title
	$Control/From/DistributerLabel.text = order.distributer


func slide_in():
	tween.interpolate_property(self.get_child(0), 'rect_position:x', 280, 0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	
	order.shown_in_order_page = true


func slide_out():
	set_select(false)
	
	tween.interpolate_property(self.get_child(0), 'rect_position:x', 0, 280, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()


func _on_Tween_tween_completed(object, key):
	if order.completed == true:
		self.queue_free()
		OrderFulfillment.refresh_order_panel_ui()


func _on_OrderSlot_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
				if event.pressed:
					OrderFulfillment.select_order_slot(self)


func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			$FocusCursor.visible = true
			
			# TODO: When the GUI focus system is implemented, make this change the current focus
		NOTIFICATION_MOUSE_EXIT:
			if selected == false:
				$FocusCursor.visible = false

