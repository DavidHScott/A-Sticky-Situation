extends NinePatchRect

var slot_save_data:SaveData

signal slot_selected()


func populate_slot(save_data:SaveData):
	slot_save_data = save_data
	
	$VBoxContainer/NameAndMoney/PlayerNameLabel.text = save_data.player_name
	$VBoxContainer/NameAndMoney/MoneyLabel.text = "$" + str(save_data.money)
	$VBoxContainer/DateAndDay/DayLabel.text = "Day " + str(save_data.current_day)
	
	var date = str(save_data.last_modified["Day"]) + "/" + str(save_data.last_modified["Month"]) + "/" + str(save_data.last_modified["Year"])
	
	$VBoxContainer/DateAndDay/LastPlayedLabel.text = "Played: " + date

func select_slot():
	emit_signal("slot_selected")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				select_slot()
