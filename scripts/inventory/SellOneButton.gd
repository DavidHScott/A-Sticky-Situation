extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_text()
	
	PlayerVariables.connect("clear_info_panel", self, "clear_text")
	PlayerVariables.connect("slot_select", self, "add_text")

func add_text(item_index):
	var item_sell_price = Market.get_item_price(PlayerVariables.inventory[item_index])
	
	$Label.text = "SELL 1 (" + str(item_sell_price) + ")"

func clear_text():
	$Label.text = "SELL 1 ()"
