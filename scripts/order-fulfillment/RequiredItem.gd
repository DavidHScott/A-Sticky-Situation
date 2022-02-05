extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func edit_text(req_item:Item = null):
	$QuantityLabel.text = str(req_item.quantity) + "x"
	
	if req_item.grade != null:
		$GradeRequirement/GradeLabel.text = req_item.grade
	else:
		$GradeRequirement/GradeLabel.text = "Any"
	
	if req_item.quality != null:
		$QualityRequirement/QualityLabel.text = ">" + str(req_item.quality) + "/100"
	else:
		$QualityRequirement/QualityLabel.text = "Any"
