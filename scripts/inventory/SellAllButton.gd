extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	clear_text()
	
	Global.connect("clear_info_panel", self, "clear_text")
	Global.connect("slot_select", self, "add_text")
	
func add_text(item_index):
	var item_price = Market.get_item_price(PlayerVariables.inventory[item_index])
	var all_item_price = item_price * PlayerVariables.inventory[item_index].get_quantity()
	
	$Label.text = "SELL ALL (" + str(all_item_price) + ")"

func clear_text():
	$Label.text = "SELL ALL ()"
