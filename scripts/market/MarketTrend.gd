extends Object

class_name MarketTrend

var rng = RandomNumberGenerator.new()

# Current trend
enum trends {
	UPWARDS,
	DOWNWARDS,
	STABLE
}
var current_trend = trends.STABLE
var trend_start_price
var trend_target_price

var upper_delta = 0.05
var lower_delta = 0.05

# Current price assumes 100/100 quality
var current_base_price = 1000
var price_history = []

var day = 0

func generate_new_price():
	day += 1
	
	rng.randomize()
	var delta_variation = rng.randf_range(1 - lower_delta, 1 + upper_delta)
	
	current_base_price = ((trend_start_price + (trend_target_price - trend_start_price) * (day as float / 7)) * delta_variation) as int
	price_history.append(current_base_price)

# Randomize the trend for the next week
func randomize_trend():
	
	rng.randomize()
	
	current_trend = randi() % 3
	
	trend_start_price = current_base_price
	match current_trend:
		trends.UPWARDS:
			trend_target_price = (trend_start_price * rng.randf_range(1.3, 2)) as int
		trends.STABLE:
			trend_target_price = (trend_start_price * rng.randf_range(0.05, 1.05)) as int
		trends.DOWNWARDS:
			trend_target_price = (trend_start_price * rng.randf_range(0.2, 0.7)) as int
	
	day = 0

func increment_upper_delta():
	pass

func increment_lower_delta():
	pass

func _ready():
	rng.randomize()
