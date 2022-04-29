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
	$ItemInformation/Producer/Variable.text = item.get_producer()
	$ItemInformation/Quality/Variable.text = str(item.get_quality()) + "/100"
	$ItemInformation/BuyPrice/Variable.text = "$" + str(item.get_buy_price()) + "/ea"
	$ItemInformation/Quantity/Variable.text = str(item.get_quantity())

func clear_item_info_panel():
	$ItemInformation/SyrupGrade/Variable.text = ""
	$ItemInformation/Producer/Variable.text = ""
	$ItemInformation/Quality/Variable.text = ""
	$ItemInformation/BuyPrice/Variable.text = ""
	$ItemInformation/Quantity/Variable.text = ""

func shopping_update_item_info(item_index):
	
	var item = ShoppingController.shop[item_index]
	
	$ItemInformation/SyrupGrade/Variable.text = item.get_grade()
	$ItemInformation/Producer/Variable.text = item.get_producer()
	$ItemInformation/Quality/Variable.text = str(item.get_quality()) + "/100"
	$ItemInformation/BuyPrice/Variable.text = "$" + str(item.get_buy_price()) + "/ea"
	$ItemInformation/Quantity/Variable.text = str(item.get_quantity())
