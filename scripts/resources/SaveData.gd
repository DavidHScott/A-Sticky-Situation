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
export var inventory_size = 0
export var inventory = []

# TODO: Implement warehouse upgrades
export var available_warehouse_upgrades = 0

export var current_day = 0

export var max_orders = 2
export var generate_random_orders = false

# Key is the quest key. Value is bool; Accepted or not
export var available_quest_keys = {
	
}

# Key is the quest key. Value is bool; successful or not
export var previous_quest_keys = {
	
}

export var golden_trend_filename = ""
export var amber_trend_filename = ""
export var dark_trend_filename = ""
export var verydark_trend_filename = ""

export var unlocked_start_day = false
export var unlocked_warehouse = false
