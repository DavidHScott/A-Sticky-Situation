extends NinePatchRect

var slot_count

var selected_item_index = null
var selected_item = null

onready var inventory_slots = $GridContainer

var slot_scene = preload("res://scenes/gui_components/page_panels/Slot.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.connect("slot_select", self, "new_selected_item")
	# TODO: Why are we unselecting when the game state switches???
	Global._game().connect("game_state_switch", self, "clear_selected_item")
	
	refresh_inventory_panel()


func refresh_inventory_panel():
	
	for slot in $GridContainer.get_children():
		$GridContainer.remove_child(slot)
	
	slot_count = PlayerVariables.inventory_size
	
	# Set items in slots based on inventory data
	for i in slot_count:
		# First create the slot
		var slot = slot_scene.instance()
		$GridContainer.add_child(slot)
		
		# If the player owns an item in the current slot, add it.
		if PlayerVariables.inventory[i] != null:
			# $GridContainer.get_child(i).set_item(i)
			slot.set_item(i)
	
	resize_inventory_panel()
	clear_selected_item()
	
	# Upgrade button
	
	# The upgrade button should only be visible if there is an upgrade available
	if PlayerVariables.available_warehouse_upgrades > 0:
		$UpgradeButton.visible = true
		$UpgradeButton/Label.text = "Upgrade ($" + str(PlayerVariables.upcoming_upgrade_costs[0]) + ")"
		
		# But should be disabled if the player doesn't have the cash
		if PlayerVariables.money < PlayerVariables.upcoming_upgrade_costs[0]:
			$UpgradeButton.disabled = true
		else:
			$UpgradeButton.disabled = false
	else:
		$UpgradeButton.visible = false


func new_selected_item(item_index):
	selected_item = PlayerVariables.inventory[item_index]
	selected_item_index = item_index


func clear_selected_item():
	selected_item = null
	selected_item_index = null
	PlayerVariables.clear_item_info_panel()


func _on_SellOneButton_pressed():
	# Make sure item exists. Get the sell price
	if selected_item == null:
		return
	var sell_price = Market.get_item_price(selected_item)
	
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
		
		PlayerVariables.clear_item_info_panel()
	else:
		PlayerVariables.slot_selected(selected_item_index)
	
	# Give money to player
	PlayerVariables.increment_players_money(sell_price)
	SaveAndLoad.save_current_game()


func _on_SellAllButton_pressed():
	if selected_item == null:
		return
	var sell_price = Market.get_item_price(selected_item) * selected_item.get_quantity()
	
	# Remove the item from the inventory
	PlayerVariables.inventory[selected_item_index] = null
	
	# Remove the item from the slot
	$GridContainer.get_child(selected_item_index).remove_item()
	
	# Clear reference to item
	clear_selected_item()
	
	PlayerVariables.clear_item_info_panel()
	
	# Give money to the player
	PlayerVariables.increment_players_money(sell_price)
	SaveAndLoad.save_current_game()


# Resize the panel and GridContainer based on the number of slots that need to be
#	Shown. We are always going to assume the player's inventory space is a multiple of 4
func resize_inventory_panel():
	var rows = slot_count / 4
	var grid_padding = abs($GridContainer.margin_top) + abs($GridContainer.margin_bottom)
	var slot_padding = $GridContainer.get_constant("vseparation")
	var slot_size = $GridContainer.get_child(0).rect_min_size.y
	
	var new_panel_size = (slot_size * rows) + (slot_padding * (rows - 1)) + grid_padding
	
	self.rect_size.y = new_panel_size


func _on_UpgradeButton_pressed():
	# call a function in PlayerVariables to increase the size of the inventory
	PlayerVariables.upgrade_inventory()
	
	# Refresh the inventory panel
	refresh_inventory_panel()
