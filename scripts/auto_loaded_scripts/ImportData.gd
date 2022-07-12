extends Node

var main_order_data
var random_order_templates

func _ready():
	import_main_orders()
	import_random_order_templates()


func import_main_orders():
	var main_orderdata_file = File.new()
	main_orderdata_file.open("res://data/orders_main.json", File.READ)
	var main_orderdata_json = JSON.parse(main_orderdata_file.get_as_text())
	main_orderdata_file.close()
	
	main_order_data = main_orderdata_json.result


# TODO: Add functionality
func import_random_order_templates():
	var rand_orderdata_file = File.new()
	rand_orderdata_file.open("res://data/orders_rand_templates.json", File.READ)
	var rand_orderdata_json = JSON.parse(rand_orderdata_file.get_as_text())
	rand_orderdata_file.close()
	
	random_order_templates = rand_orderdata_json.result
