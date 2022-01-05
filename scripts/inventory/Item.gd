extends Object

class_name Item

# Item attributes
var grade = Global.GOLDEN
var producer = "Sugar Shack inc."
var quality = 69
var buy_price = 420
var quantity = 69

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
