extends Node

var main_order_data

func _ready():
	var main_orderdata_file = File.new()
	main_orderdata_file.open("res://data/orders_main.json", File.READ)
	var main_orderdata_json = JSON.parse(main_orderdata_file.get_as_text())
	main_orderdata_file.close()
	
	main_order_data = main_orderdata_json.result
