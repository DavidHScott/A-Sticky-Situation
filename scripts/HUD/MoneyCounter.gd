extends NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.connect("money_was_updated", self, "update_money_counter")
	
	$Label.text = "$ " + str(PlayerVariables.get_players_money())

func update_money_counter(new_total):
	$Label.text = "$ " + str(new_total)
