extends NinePatchRect

export var enabled = false

#var sprite_enabled = preload("res://ui_themes/themes/SlotThemes/slot_enabled.tres")
#var sprite_disabled = preload("res://ui_themes/themes/SlotThemes/slot_disabled.tres")

var invItem_class = preload("res://scenes/gui_components/page_panels/InventoryItem.tscn")
var item = null
var item_index = null

var selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not enabled:
		pass
		#add_stylebox_override("panel", sprite_disabled)
	else:
		pass
		#add_stylebox_override("panel", sprite_enabled)

func enable_slot():
	enabled = true
	#add_stylebox_override("panel", sprite_enabled)
	
	
func disable_slot():
	enabled = false
	#add_stylebox_override("panel", sprite_disabled)

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
					Global.slot_selected(item_index)

func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			$FocusCursor.visible = true
			
			# TODO: When the GUI focus system is implemented, make this change the current focus
		NOTIFICATION_MOUSE_EXIT:
			if selected != false:
				$FocusCursor.visible = false
