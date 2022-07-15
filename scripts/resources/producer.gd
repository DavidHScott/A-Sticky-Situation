extends Resource
class_name Producer

# Full name is used in most text. abbreviated name is used for string formatting
# 	and anywhere with less room for text
export(String) var full_name = null
export(String) var abr_name = null

# Whether or not the producer is able to sell in the market
export(bool) var active = false

# For random products. Set minimum / possible syrup attributes
#
# If array is empty, no restrictions, if there is at least one, they can only
# 	sell listed grades
export(Array) var allowed_grades = []
export(int) var minimum_quality = 0
export(int) var maximum_quality = 100

# Slightly changes the price of goods
#
# 0 - Undercharges by a lot
# 1 - Undercharges a little
# 2 - Keeps with the market
# 3 - Overcharges a little
# 4 - Overcharges by a lot
export(int) var price_habits = 0


# If a quest or event currenly demands it, there can be required items forced onto the market
export(bool) var important_goods = false

# Array of arrays. [ [grade, min_quality], [grade, min_quality] ] 
# This is set only when there is an order that requires it
export(Array) var important_goods_restrictions


func _init(_abr_name = "ABR", _full_name = "Name", _active = false, _price_habits = 0, _allow_grades = [], _min_qual = 0, _max_qual = 100):
	abr_name = _abr_name
	full_name = _full_name
	active = _active
	price_habits = _price_habits
	allowed_grades = _allow_grades
	minimum_quality = _min_qual
	maximum_quality = _max_qual
