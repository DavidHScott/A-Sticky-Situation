extends Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("slot_select", self, "update_item_info")

func update_item_info(item_index):
	
	var item = PlayerVariables.inventory[item_index]
	
	$ItemInformation/SyrupGrade/Variable.text = item.get_grade()
	$ItemInformation/Producer/Variable.text = item.get_producer()
	$ItemInformation/Quality/Variable.text = str(item.get_quality()) + "/100"
	$ItemInformation/BuyPrice/Variable.text = "$" + str(item.get_buy_price()) + "/ea"
	$ItemInformation/Quantity/Variable.text = str(item.get_quantity())
