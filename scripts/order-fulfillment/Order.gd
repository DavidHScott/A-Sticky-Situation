extends Resource

class_name Order

# Order attributes
var title: String
var distributer: String
var job_description: String
var pay: int
var overdue_pay: int

var requirements = []
var prereq_keys = []

# The amount of time the order remains in the menu before disapearing.
# If the value is 0, the order does not expire
var accept_timelimit = 0
# The amount of time the player has to fulfill the order
# If the value is 0, the order does not expire
var fulfill_timelimit = 0

# 0 = false, 1 = true
var wait_day_to_unlock = 0

var reward_reputation = 0
var required_reputation = 0

# Other variables
var days_since_init = 0
var days_since_accept = 0

var shown_in_order_page = false

var accepted: bool = false
var overdue: bool = false
var completed: bool = false

var expired: bool = false

func _init(order_title:String = "Placeholder",
		order_distributer:String = "Name", order_desc:String = "Lorem Ipsum...",
		order_pay:int = 420, require_array = null, timelimit: int = 0,
		deadline: int = 0, prereq = null, wait = 0, reward_rep = 0, required_rep = 0):
	title = order_title
	distributer = order_distributer
	job_description = order_desc
	pay = order_pay
	requirements = require_array
	accept_timelimit = timelimit
	fulfill_timelimit = deadline
	prereq_keys = prereq
	wait_day_to_unlock = wait
	
	# 20% discount if the player is late. May change this later
	overdue_pay = pay * 0.8

func set_items(item_array: Array):
	requirements = item_array


func copy_values_from(from_order):
	title = from_order.title
	distributer = from_order.distributer
	job_description = from_order.job_description
	pay = from_order.pay
	requirements = from_order.requirements
	accept_timelimit = from_order.accept_timelimit
	fulfill_timelimit = from_order.fulfill_timelimit
	prereq_keys = from_order.prereq_keys
	wait_day_to_unlock = from_order.wait_day_to_unlock


func new_day():
	if !overdue:
		if !accepted:
			days_since_init += 1
		
			if accept_timelimit != 0 and days_since_init >= accept_timelimit:
				expired = true
		else:
			days_since_accept += 1
			
			if fulfill_timelimit != 0 and days_since_accept > fulfill_timelimit:
				# Remove the item
				overdue = true

func accept_order():
	SaveAndLoad.save_current_game()
	accepted = true
	
	if requirements == null:
		complete_order()

func complete_order():
	completed = true

func is_completed():
	return completed

func is_expired():
	return expired

func is_accepted():
	return accepted
