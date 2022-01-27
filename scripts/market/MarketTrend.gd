extends Object

class_name MarketTrend

# Current trend
enum trends {
	UPWARDS,
	DOWNWARDS,
	STABLE
}
var current_trend = trends.STABLE
var trend_start_price
var trend_target_price

# Current price assumes 100/100 quality
var current_base_price = 100
var price_history = []

func generate_new_price():
	pass

# Randomize the trend for the next week
func randomize_trend():
	current_trend = randi() % 3
	
	trend_start_price = current_base_price
	
	pass

func _ready():
	randomize()
