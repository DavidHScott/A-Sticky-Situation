extends Tween

onready var parent = get_parent()

func _ready():
	parent.connect("visibility_changed", self, "slide_up")

func slide_up():
	interpolate_property(parent, 'rect_position:y', 60, 59 - parent.rect_size.y, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	start()


func slide_down():
	interpolate_property(parent, 'rect_position:y', 59 - parent.rect_size.y, 60, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	start()
	pass
