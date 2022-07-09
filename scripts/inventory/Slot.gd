extends NinePatchRect

export var enabled = true

var invItem_class = preload("res://scenes/gui_components/page_panels/InventoryItem.tscn")
var item = null
var item_index = null

var selected = false


func set_item(newItem_index):
	item = PlayerVariables.inventory[newItem_index]
	item_index = newItem_index
	
	var invItem = invItem_class.instance()
	
	self.add_child(invItem)

func remove_item():
	item = null
	item_index = null
	
	self.get_child(1).queue_free()

func _gui_input(event):
	# Check if the slot was clicked
	if enabled and item != null:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if event.pressed:\
					PlayerVariables.slot_selected(item_index)

func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			$FocusCursor.visible = true
			
			# TODO: When the GUI focus system is implemented, make this change the current focus
		NOTIFICATION_MOUSE_EXIT:
			if selected == false:
				$FocusCursor.visible = false
