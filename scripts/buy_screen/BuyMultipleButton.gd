extends Button

var buy_mult_spinbox

# Called when the node enters the scene tree for the first time.
func _ready():
	ShoppingController.connect("shop_slot_select", self, "update_max_value")
	buy_mult_spinbox = $SpinBox

func _on_BuyMultipleButton_pressed():
	ShoppingController.sell_shop_item(buy_mult_spinbox.value)

func update_max_value(item_index):
	buy_mult_spinbox.value = 1
	buy_mult_spinbox.max_value = ShoppingController.shop[item_index].get_quantity()
