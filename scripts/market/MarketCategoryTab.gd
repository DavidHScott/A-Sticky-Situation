extends NinePatchRect

enum grade {GOLDEN, AMBER, DARK, VERY_DARK}

export (grade) var tab_type
var grade_var

var selected = false setget set_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	match tab_type:
		grade.GOLDEN:
			grade_var = Global._game().GOLDEN
		grade.AMBER:
			grade_var = Global._game().AMBER
		grade.DARK:
			grade_var = Global._game().DARK
		grade.VERY_DARK:
			grade_var = Global._game().VERY_DARK


func set_selected(s):
	selected = s
	$FocusCursor.visible = s
	pass


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				Market.change_view_category(grade_var)


func _notification(what):
	match what:
		NOTIFICATION_MOUSE_ENTER:
			$FocusCursor.visible = true
			
			# TODO: When the GUI focus system is implemented, make this change the current focus
		NOTIFICATION_MOUSE_EXIT:
			if selected == false:
				$FocusCursor.visible = false
