extends Node

var golden_trend = MarketTrend.new()
var amber_trend = MarketTrend.new()
var dark_trend = MarketTrend.new()
var verydark_trend = MarketTrend.new()

signal change_view(grade)
signal change_timeline()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func new_day():
	# The start of a new week. Day 1, day 8, etc
	if (Global.current_day - 1) % 7 == 0:
		new_week()
	
	golden_trend.generate_new_price()
	amber_trend.generate_new_price()
	dark_trend.generate_new_price()
	verydark_trend.generate_new_price()

# Gets called every 7 days. Day 1, Day 8, etc.
func new_week():
	golden_trend.randomize_trend()
	amber_trend.randomize_trend()
	dark_trend.randomize_trend()
	verydark_trend.randomize_trend()

func get_item_price(item):
	
	var item_price
	
	if item.get_grade() == Global.AMBER:
		item_price = amber_trend.current_base_price
	elif item.get_grade() == Global.GOLDEN:
		item_price = golden_trend.current_base_price
	elif item.get_grade() == Global.DARK:
		item_price = dark_trend.current_base_price
	elif item.get_grade() == Global.VERY_DARK:
		item_price = verydark_trend.current_base_price
	else:
		return
	
	return item_price

func change_view_category(grade):
	emit_signal("change_view", grade)

func change_timeline_view():
	emit_signal("change_timeline")
