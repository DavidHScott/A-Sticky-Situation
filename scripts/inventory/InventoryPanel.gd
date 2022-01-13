extends NinePatchRect

var slots = []

var selected_item_index = null
var selected_item = null

onready var inventory_slots = $GridContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("slot_select", self, "new_selected_item")
	Global.connect("game_state_switch", self, "clear_selected_item")
	
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
	Global.clear_item_info_panel()

func _on_SellOneButton_pressed():
	# Make sure item exists. Get the sell price
	if selected_item == null:
		return
	var sell_price = Global.get_item_sell_price(selected_item)
	
	# Remove one of the item from the inventory
	PlayerVariables.inventory[selected_item_index].set_quantity(selected_item.get_quantity() - 1)

	# Check if that was the last item in stack, and if so, remove item entirly
	if PlayerVariables.inventory[selected_item_index].get_quantity() < 1:
		# remove item from inventory,
		PlayerVariables.inventory[selected_item_index] = null
		
		# Remove the item from the slot
		$GridContainer.get_child(selected_item_index).remove_item()
		
		# Clear reference to item
		clear_selected_item()
		
		Global.clear_item_info_panel()
	else:
		Global.slot_selected(selected_item_index)
	
	# Give money to player
	PlayerVariables.increment_players_money(sell_price)


func _on_SellAllButton_pressed():
	if selected_item == null:
		return
	var sell_price = Global.get_item_sell_price(selected_item) * selected_item.get_quantity()
	
	# Remove the item from the inventory
	PlayerVariables.inventory[selected_item_index] = null
	
	# Remove the item from the slot
	$GridContainer.get_child(selected_item_index).remove_item()
	
	# Clear reference to item
	clear_selected_item()
	
	Global.clear_item_info_panel()
	
	# Give money to the player
	PlayerVariables.increment_players_money(sell_price)
