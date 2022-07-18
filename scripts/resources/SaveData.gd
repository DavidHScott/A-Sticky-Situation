extends Resource
class_name SaveData

export var save_data_version = "0.1"
export var filename = ""
export var last_modified = {
	"Day": 1,
	"Month": 1,
	"Year": 1970
}

# Player Variables
export var player_name = ""
export var money = 0
export var reputation = 0
export var inventory_size = 0
export var inventory:Array

export var beat_game = false

export var available_warehouse_upgrades = 0
export var upcoming_upgrade_costs = [1000, 2000]

export var current_day = 0

export var max_orders = 2
export var generate_random_orders = false

# Lists available quests. Stores whether or not the order is accepted, if it's overdue, etc.
export var available_quests:Array = []

# just lists the keys of the previous quests. This may be expanded in the future
export var previous_quests:Array

export var golden_trend_filename = ""
export var amber_trend_filename = ""
export var dark_trend_filename = ""
export var verydark_trend_filename = ""

export var unlocked_start_day = false
export var unlocked_warehouse = false
export var unlocked_market = false
