extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_line(Vector2(50, 50), Vector2(500, 500), Color(255, 255, 255, 1), 3, false)	
