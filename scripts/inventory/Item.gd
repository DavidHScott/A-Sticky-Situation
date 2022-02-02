extends Object

class_name Item

# Item attributes
var grade
var producer
var quality
var buy_price
var quantity

func _init(item_grade = null, item_producer = null,
		item_quality = null, item_quantity = null):
	grade = item_grade
	producer = item_producer
	quality = item_quality
	quantity = item_quantity

func set_grade(new_grade):
	grade = new_grade

func get_grade():
	return grade

func set_producer(new_producer):
	producer = new_producer

func get_producer():
	return producer

func set_quality(new_quality):
	quality = new_quality

func get_quality():
	return quality

func set_buy_price(price):
	buy_price = price

func get_buy_price():
	return buy_price
	
func set_quantity(new_quantity):
	quantity = new_quantity

func get_quantity():
	return quantity

func copy_item(old_item):
	set_grade(old_item.get_grade())
	set_producer(old_item.get_producer())
	set_quality(old_item.get_quality())
	set_buy_price(old_item.get_buy_price())
	set_quantity(old_item.get_quantity())

func compare_items(other_item):
	if other_item.get_grade() == grade and other_item.get_producer() == producer and other_item.get_quality() == quality and other_item.get_buy_price() == buy_price:
		return true
	else:
		return false
