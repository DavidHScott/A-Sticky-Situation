extends HBoxContainer

func populate_data(item:Item):
	$QuantityLabel.text = str(item.quantity) + "x"
	$Grade/ItemGrade.text = item.grade
	$Producer/ItemProducer.text = item.producer
	$Quality/ItemQuality.text = str(item.quality) + "/100"
	$BuyPrice/ItemBuyPrice.text = "$" + str(item.buy_price)
