extends NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready():
	Market.connect("change_view", self, "change_market_view_category")
	Market.connect("change_timeline", self, "change_timeline_view")

func change_market_view_category(grade):
	$MarketGraphic.change_grade_view(grade)

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
