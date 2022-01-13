extends Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_BuyOneButton_pressed():
	ShoppingController.sell_shop_item(1)
