extends Control

func _ready():
	Global.connect("close_current_page", self, "close_page")

func close_page():
	queue_free()
