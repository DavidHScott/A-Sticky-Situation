extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("close_current_page", self, "close_page")


func close_page():
	queue_free()
