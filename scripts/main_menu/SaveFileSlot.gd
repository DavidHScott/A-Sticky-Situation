extends NinePatchRect

var slot_save_data:SaveData
var disabled = false

signal slot_selected()


func populate_slot(save_data:SaveData):
	slot_save_data = save_data
	
	$VBoxContainer/NameAndMoney/PlayerNameLabel.text = save_data.player_name
	
	var date = str(save_data.last_modified["Day"]) + "/" + str(save_data.last_modified["Month"]) + "/" + str(save_data.last_modified["Year"])
	
	$VBoxContainer/DateAndDay/LastPlayedLabel.text = "Played: " + date
	
	if slot_save_data.beat_game == false:
		$VBoxContainer/NameAndMoney/MoneyLabel.text = "$" + str(save_data.money)
		$VBoxContainer/DateAndDay/DayLabel.text = "Day " + str(save_data.current_day)
		
		disabled = false
	else:
		$VBoxContainer/NameAndMoney/MoneyLabel.text = "COMPLETED"
		$VBoxContainer/DateAndDay/DayLabel.text = ""
		
		disabled = true

func select_slot():
	emit_signal("slot_selected")

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and disabled == false:
			if event.pressed:
				select_slot()
