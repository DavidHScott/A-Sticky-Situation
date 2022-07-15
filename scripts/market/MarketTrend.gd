extends Resource
class_name MarketTrend

var rng = RandomNumberGenerator.new()

# Current trend
enum trends {
	UPWARDS,
	DOWNWARDS,
	STABLE
}
export var current_trend = trends.STABLE
export var trend_start_price:int
export var trend_target_price:int

export var upper_delta = 0.05
export var lower_delta = 0.05

# Current price assumes 100/100 quality
export var current_base_price = 800
export var price_history:Array

export var day = 0

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
			trend_target_price = (trend_start_price * rng.randf_range(1.2, 1.5)) as int
		trends.STABLE:
			trend_target_price = (trend_start_price * rng.randf_range(0.05, 1.05)) as int
		trends.DOWNWARDS:
			trend_target_price = (trend_start_price * rng.randf_range(0.1, 0.4)) as int
	
	day = 0

func increment_upper_delta():
	pass

func increment_lower_delta():
	pass

func _ready():
	rng.randomize()


func clear_trend():
	current_trend = trends.STABLE
	
	upper_delta = 0.05
	lower_delta = 0.05
	
	current_base_price = 800
	price_history.clear()
	
	day = 0
