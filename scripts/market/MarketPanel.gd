extends NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready():
	Market.connect("change_view", self, "change_market_view_category")
	Market.connect("change_timeline", self, "change_timeline_view")

func change_market_view_category(grade):
	$MarketGraphic.change_grade_view(grade)
	
	var selected_grade_trend
	
	if $MarketGraphic.selected_grade_view == $MarketGraphic.grade_views.AMBER:
		selected_grade_trend = Market.amber_trend.current_trend
		
		$Tabs/AmberTab.selected = true
		$Tabs/GoldenTab.selected = false
		$Tabs/DarkTab.selected = false
		$Tabs/VerydarkTab.selected = false
	elif $MarketGraphic.selected_grade_view == $MarketGraphic.grade_views.GOLDEN:
		selected_grade_trend = Market.golden_trend.current_trend
		
		$Tabs/AmberTab.selected = false
		$Tabs/GoldenTab.selected = true
		$Tabs/DarkTab.selected = false
		$Tabs/VerydarkTab.selected = false
	elif $MarketGraphic.selected_grade_view == $MarketGraphic.grade_views.DARK:
		selected_grade_trend = Market.dark_trend.current_trend
		
		$Tabs/AmberTab.selected = false
		$Tabs/GoldenTab.selected = false
		$Tabs/DarkTab.selected = true
		$Tabs/VerydarkTab.selected = false
	elif $MarketGraphic.selected_grade_view == $MarketGraphic.grade_views.VERY_DARK:
		selected_grade_trend = Market.verydark_trend.current_trend
		
		$Tabs/AmberTab.selected = false
		$Tabs/GoldenTab.selected = false
		$Tabs/DarkTab.selected = false
		$Tabs/VerydarkTab.selected = true
	
	if selected_grade_trend == MarketTrend.trends.UPWARDS:
		$HBoxContainer/PredictedTrendVar.text = "UP"
	elif selected_grade_trend == MarketTrend.trends.STABLE:
		$HBoxContainer/PredictedTrendVar.text = "STABLE"
	elif selected_grade_trend == MarketTrend.trends.DOWNWARDS:
		$HBoxContainer/PredictedTrendVar.text = "DOWN"
	


func change_timeline_view():
	var new_time_view = $MarketGraphic.change_timeline_view()
	
	if new_time_view == $MarketGraphic.time_view_types.WEEK:
		$TimelineButton/Label.text = "WEEK"
	elif new_time_view == $MarketGraphic.time_view_types.TWO_WEEKS:
		$TimelineButton/Label.text = "2 WEEKS"
	elif new_time_view == $MarketGraphic.time_view_types.FOUR_WEEKS:
		$TimelineButton/Label.text = "4 WEEKS"
	elif new_time_view == $MarketGraphic.time_view_types.ALL_TIME:
		$TimelineButton/Label.text = "ALL TIME"
