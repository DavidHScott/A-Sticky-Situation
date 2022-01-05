extends Panel

var slots = []

var selected_item_index = null
var selected_item = null

onready var inventory_slots = $GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("slot_select", self, "")
	
	# Enable slots based on inventory size
	for i in PlayerVariables.inventory_size-1:
		$GridContainer.get_child(i).enable_slot()
		
		if PlayerVariables.inventory[i] != null:
			$GridContainer.get_child(i).set_item(i)
	
	
	# Add items to the slots based on the inventory array

func new_selected_item(item_index):
	selected_item = PlayerVariables.inventory[item_index]
	selected_item_index = item_index

func clear_selected_item():
	selected_item = null
	selected_item_index = null

func _on_SellOneButton_pressed():
	
	# Make sure item exists. Get the sell price
	if selected_item == null:
		return
	
	var sell_price = Global.get_item_sell_price(selected_item)
	
	# Remove one of the item from the inventory
	PlayerVariables.inventory[selected_item_index].set_quantity(selected_item.get_quantity - 1)

	# Check if that was the last item in stack, and if so, remove item entirly
	if PlayerVariables.inventory[selected_item_index].get_quantity() < 1:
		# remove item from inventory,
		pass
	else:
		pass
	
	# Refresh UI
	
	pass # Replace with function body.


func _on_SellAllButton_pressed():
	pass # Replace with function body.
