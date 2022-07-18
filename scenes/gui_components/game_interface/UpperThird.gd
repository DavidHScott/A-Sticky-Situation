extends HBoxContainer


func _on_UpperThird_visibility_changed():
	slide_down()


func slide_down():
	$Tween.interpolate_property(self, 'rect_position:y', -64, 0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
