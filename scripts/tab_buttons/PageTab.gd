extends Button


func show_notification():
	$Notification.visible = true
	$Notification/AnimationPlayer.play("Flash")


func hide_notification():
	$Notification.visible = false


func _on_PageTab_pressed():
	hide_notification()
