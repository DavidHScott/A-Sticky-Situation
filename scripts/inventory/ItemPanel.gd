extends NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.connect("slot_select", self, "update_item_info")
	PlayerVariables.connect("clear_info_panel", self, "clear_item_info_panel")
	
	ShoppingController.connect("shop_slot_select", self, "shopping_update_item_info")
	
	clear_item_info_panel()

func update_item_info(item_index):
	var item = PlayerVariables.inventory[item_index]
	
	$ItemInformation/SyrupGrade/Variable.text = item.get_grade()
	$ItemInformation/Producer/Variable.text = ShoppingController.producers_dict[item.producer].full_name
	$ItemInformation/Quality/Variable.text = str(item.get_quality()) + "/100"
	$ItemInformation/BuyPrice/Variable.text = "$" + str(item.get_buy_price()) + "/ea"
	$ItemInformation/Quantity/Variable.text = str(item.get_quantity())
	
	check_text_for_clipping($ItemInformation/Producer/Variable)

func clear_item_info_panel():
	$ItemInformation/SyrupGrade/Variable.text = ""
	$ItemInformation/Producer/Variable.text = ""
	$ItemInformation/Quality/Variable.text = ""
	$ItemInformation/BuyPrice/Variable.text = ""
	$ItemInformation/Quantity/Variable.text = ""

func shopping_update_item_info(item_index):
	
	var item = ShoppingController.shop[item_index]
	
	$ItemInformation/SyrupGrade/Variable.text = item.get_grade()
	$ItemInformation/Producer/Variable.text = ShoppingController.producers_dict[item.producer].full_name
	$ItemInformation/Quality/Variable.text = str(item.get_quality()) + "/100"
	$ItemInformation/BuyPrice/Variable.text = "$" + str(item.get_buy_price()) + "/ea"
	$ItemInformation/Quantity/Variable.text = str(item.get_quantity())
	
	check_text_for_clipping($ItemInformation/Producer/Variable)


func check_text_for_clipping(label:Label):
	var label_size = label.rect_size.x
	var label_text = label.text
	
	if label_size > label.get_font("res://ui_themes/fonts/default_dynamicfont.tres").get_string_size(label.text + "...").x:
		return
	
	while label_size < label.get_font("res://ui_themes/fonts/default_dynamicfont.tres").get_string_size(label.text + "...").x:
		label_text.erase(label_text.length() - 1, 1)
		
		label.text = label_text
	
	label.text += "..."
