extends Control

enum time_view_types {
	WEEK,
	TWO_WEEKS,
	FOUR_WEEKS,
	ALL_TIME
}

var selected_time_view = time_view_types.WEEK

enum grade_views {
	AMBER,
	GOLDEN,
	DARK,
	VERY_DARK
}

var selected_grade_view = grade_views.AMBER

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	
	remove_child(get_child(0))
	
	var view_width = self.get_size().x - 6
	var top = 6
	var bottom = self.get_size().y - 6
	var historical_prices = []
	var numof_lines
	
	# All of the data points. Holds vec2s with the x and y of the node
	var all_top_points = []
	
	# Dealing with height. I don't want to fill the whole screen
	var view_height = self.get_size().y * 0.8
	
	# Get the grade to render
	match selected_grade_view:
		grade_views.AMBER:
			historical_prices = Market.amber_trend.price_history.duplicate()
		grade_views.GOLDEN:
			historical_prices = Market.golden_trend.price_history.duplicate()
		grade_views.DARK:
			historical_prices = Market.dark_trend.price_history.duplicate()
		grade_views.VERY_DARK:
			historical_prices = Market.verydark_trend.price_history.duplicate()
	
	# Get the period of time
	match selected_time_view:
		time_view_types.WEEK:
			if historical_prices.size() < 7:
				numof_lines = historical_prices.size()
			else:
				numof_lines = 7
		time_view_types.TWO_WEEKS:
			if historical_prices.size() < 14:
				numof_lines = historical_prices.size()
			else:
				numof_lines = 14
		time_view_types.FOUR_WEEKS:
			if historical_prices.size() < 28:
				numof_lines = historical_prices.size()
			else:
				numof_lines = 28
		time_view_types.ALL_TIME:
			numof_lines = historical_prices.size()
	
	# Take the selected period of time, and just select those data points to render
	historical_prices = historical_prices.slice(-numof_lines, -1)
	# Calculate the space between the nodes
	var line_spacing = view_width / (numof_lines)
	
	# Get the largest data point. This will take up 80% of the view, and the rest of 
	# 	the data point locations will be calculated based on this one
	var sorted_arr = historical_prices.duplicate()
	sorted_arr.sort()
	var biggest_num = sorted_arr[-1]
	
	# Get the x/y location for all of the data points
	for i in numof_lines:
		
		# Y should be a percentage of the largest number
		var line_height_percent = (historical_prices[i] as float / biggest_num as float)
		# Get the actual y pos in regards to the market viewport
		var line_height = (view_height * (1 - line_height_percent))
		
		# This makes sure the nodes don't go higher than the top of the viewport
		# NOTE: 0,0 is in the TOP LEFT. That's why the math looks weird
		line_height += self.get_size().y * 0.2
		
		# Make sure nothing goes past the bottom of the view
		if line_height >= bottom:
			line_height = bottom
			
		var vec_end = Vector2(line_spacing * i + 6, line_height)
		
		# Add the data point location to the array
		all_top_points.append(vec_end)
	
	for i in all_top_points.size():
		if i < all_top_points.size() - 1:
			var vec_start = all_top_points[i]
			var vec_end = all_top_points[i + 1]
			
			draw_line(vec_start, vec_end, Color.white, 3, false)
	
	# Get the very last point and add a label with the current price
	var last_point = all_top_points[all_top_points.size() - 1]
	
	var price_label = Label.new()
	price_label.text = "$" + str(historical_prices[historical_prices.size() - 1])
	add_child(price_label)
	
	price_label.rect_position.x = last_point.x - 30
	price_label.rect_position.y = last_point.y + 10

func change_grade_view(new_grade):
	if new_grade == Global._game().AMBER:
		selected_grade_view = grade_views.AMBER
	elif new_grade == Global._game().GOLDEN:
		selected_grade_view = grade_views.GOLDEN
	elif new_grade == Global._game().DARK:
		selected_grade_view = grade_views.DARK
	elif new_grade == Global._game().VERY_DARK:
		selected_grade_view = grade_views.VERY_DARK
	
	update()

func change_timeline_view():
	var new_time_view
	
	match selected_time_view:
		time_view_types.WEEK:
			new_time_view = time_view_types.TWO_WEEKS
		time_view_types.TWO_WEEKS:
			new_time_view = time_view_types.FOUR_WEEKS
		time_view_types.FOUR_WEEKS:
			new_time_view = time_view_types.ALL_TIME
		time_view_types.ALL_TIME:
			new_time_view = time_view_types.WEEK
	
	selected_time_view = new_time_view
	update()
	
	return selected_time_view
