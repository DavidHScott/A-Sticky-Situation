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

export var current_day = 0

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
