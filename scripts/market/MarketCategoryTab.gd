extends NinePatchRect

enum grade {GOLDEN, AMBER, DARK, VERY_DARK}

export (grade) var tab_type
var grade_var

# Called when the node enters the scene tree for the first time.
func _ready():
	match tab_type:
		grade.GOLDEN:
			grade_var = Global.GOLDEN
		grade.AMBER:
			grade_var = Global.AMBER
		grade.DARK:
			grade_var = Global.DARK
		grade.VERY_DARK:
			grade_var = Global.VERY_DARK

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				Market.change_view_category(grade_var)
