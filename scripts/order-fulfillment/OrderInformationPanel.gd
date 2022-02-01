extends NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Deactivate all the buttons until something gets selected
	$FulfillButton.visible = false
	$CancelButton.visible = false
	$AcceptButton.visible = false
