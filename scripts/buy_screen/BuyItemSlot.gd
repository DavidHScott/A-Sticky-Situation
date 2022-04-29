extends NinePatchRect

var item = null
var item_index = null

var selected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	ShoppingController.connect("shop_slot_select", self, "slot_selected")

func add_item(new_item_index):
	item_index = new_item_index
	item = ShoppingController.shop[item_index]
	
	# Make sure no errors get thrown
	if item == null:
		return
	
	$IconBackground/Icon.texture = Global._game().get_syrup_sprite(item.grade)
	$GradeLabel.text = item.grade
	$CostLabel.text = "$" + str(item.get_buy_price()) + "/ea"

func remove_item():
	queue_free()

func slot_selected(i):
	if item_index == i:
		selected = true
	else:
		selected = false
		$FocusCursor.visible = false

func _gui_input(event):
	if item != null:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if event.pressed:
					ShoppingController.slot_selected(self)

func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			$FocusCursor.visible = true
		NOTIFICATION_MOUSE_EXIT:
			if selected == false:
				$FocusCursor.visible = false
