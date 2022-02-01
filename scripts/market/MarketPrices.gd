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
	
	var view_width = self.get_size().x - 6
	var bottom = self.get_size().y - 3
	var historical_prices = []
	var numof_lines
	
	# For connecting all of the data points to make a fun graph
	var all_top_points = []
	
	# Dealing with height:
	var view_height = self.get_size().y * 0.9
	
	match selected_grade_view:
		grade_views.AMBER:
			historical_prices = Market.amber_trend.price_history.duplicate()
		grade_views.GOLDEN:
			historical_prices = Market.golden_trend.price_history.duplicate()
		grade_views.DARK:
			historical_prices = Market.dark_trend.price_history.duplicate()
		grade_views.VERY_DARK:
			historical_prices = Market.verydark_trend.price_history.duplicate()
	
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
	
	historical_prices = historical_prices.slice(-numof_lines, -1)
	var line_spacing = view_width / (numof_lines)
	
	# Adjust the height of the view so that the highest stock line goes
	# up 80% of the screen
	var sorted_arr = historical_prices.duplicate()
	sorted_arr.sort()
	var biggest_num = sorted_arr[-1]
	
	for i in numof_lines:
		
		var line_height_percent = (historical_prices[i] as float / biggest_num as float)
		var line_height = (view_height * (1 - line_height_percent))
		
		line_height += self.get_size().y * 0.1
		
		if line_height >= bottom:
			line_height = bottom
		
		var vec_start = Vector2(line_spacing * i + 10, bottom)
		var vec_end = Vector2(line_spacing * i + 10, line_height)
		
		draw_line(vec_start, vec_end, Color.white, 1, false)
		
		# Add the top point of the line to actually be able to graph it good
		all_top_points.append(vec_end)
	
	for i in all_top_points.size():
		if i < all_top_points.size() - 1:
			var vec_start = all_top_points[i]
			var vec_end = all_top_points[i + 1]
			
			draw_line(vec_start, vec_end, Color.white, 3, false)

func change_grade_view(new_grade):
	match new_grade:
		Global.AMBER:
			selected_grade_view = grade_views.AMBER
		Global.GOLDEN:
			selected_grade_view = grade_views.GOLDEN
		Global.DARK:
			selected_grade_view = grade_views.DARK
		Global.VERY_DARK:
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
