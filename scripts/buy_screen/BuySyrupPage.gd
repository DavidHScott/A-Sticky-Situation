extends Control

var buy_item_slot_scene = preload("res://scenes/gui_components/page_panels/BuyItemSlot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Global._game().connect("close_current_page", self, "close_page")
	ShoppingController.connect("refresh_shop_ui", self, "refresh_ui")
	
	refresh_ui(true)

func close_page():
	queue_free()

func refresh_ui(clear_item_panel):
	# If true, clear the info panel
	if clear_item_panel:	
		$ItemPanel.clear_item_info_panel()
	
	# Reset the SpinBox back to 1
	$BuyMultipleButton/SpinBox.value = 1
	
	# Refresh the buy panel
	var buy_item_slots = $BuyPanel/ScrollContainer/VBoxContainer
	
	if buy_item_slots.get_child_count() > 0:
		for c in buy_item_slots.get_children():
			c.remove_item()
	
	for i in ShoppingController.shop.size():
		var shop_item = buy_item_slot_scene.instance()
		shop_item.add_item(i)
		
		buy_item_slots.add_child(shop_item)
