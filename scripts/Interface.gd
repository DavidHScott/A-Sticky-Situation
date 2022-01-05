extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("open_new_page", self, "open_page")
	Global.connect("game_state_switch", self, "refresh_ui")

func open_page(ref_to_new_scene):
	var scene = ref_to_new_scene.instance()
	add_child(scene)

func refresh_ui():
	$WarehouseTab.visible = true
	$OrdersTab.visible = true
	$MarketTab.visible = true
	
	if Global.current_game_state == Global.GAME_STATE.DOWNTIME:
		$StartDayTab.visible = true
		$BuySyrupTab.visible = false
	else:
		$StartDayTab.visible = false
		$BuySyrupTab.visible = true
