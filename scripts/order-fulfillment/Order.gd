extends Object

class_name Order

# Order attributes
var title: String
var distributer: String
var job_description: String
var pay: int

var requirements = []

var prereq_key = null

# The amount of time the order remains in the menu before disapearing.
# If the value is 0, the order does not expire
var accept_timelimit = 0
# The amount of time the player has to fulfill the order
# If the value is 0, the order does not expire
var fulfill_timelimit = 0

var days_since_init = 0
var days_since_accept = 0

var accepted: bool = false
var expired: bool = false
var completed: bool = false

func _init(order_title:String = "Placeholder",
		order_distributer:String = "Name", order_desc:String = "Lorem Ipsum...",
		order_pay:int = 420, require_array:Array = [null], timelimit: int = 0,
		deadline: int = 0, prereq = null):
	title = order_title
	distributer = order_distributer
	job_description = order_desc
	pay = order_pay
	requirements = require_array
	accept_timelimit = timelimit
	fulfill_timelimit = deadline
	prereq_key = prereq
	

func set_items(item_array: Array):
	requirements = item_array

func new_day():
	if !expired:
		if !accepted:
			days_since_init += 1
		
			if accept_timelimit != 0 and days_since_init > accept_timelimit:
				# Remove the item
				expired = true
		else:
			days_since_accept += 1
			
			if fulfill_timelimit != 0 and days_since_accept > fulfill_timelimit:
				# Remove the item
				expired = true

func accept_order():
	SaveAndLoad.save_current_game()
	accepted = true

func complete_order():
	completed = true

func is_completed():
	return completed

func is_expired():
	return expired

func is_accepted():
	return accepted
