extends Control

var play_button
var delete_button
var save_container

var save_arr:Array

var save_slot = preload("res://scenes/main_menu/slots/SaveFileSlot.tscn")

# Slot selection
var selected_save_data:SaveData = null


func _ready():
	play_button = $MarginContainer/SaveSelect/VBoxContainer/HBoxContainer/PlayButton
	delete_button = $MarginContainer/SaveSelect/VBoxContainer/HBoxContainer/DeleteButton
	
	save_container = $MarginContainer/SaveSelect/VBoxContainer/NinePatchRect/ScrollContainer/SaveContainer
	
	play_button.disabled = true
	delete_button.disabled = true
	
	populate_menu()
	
	# Connect to signals from the slots when they're pressed
	for node in save_container.get_children():
		node.connect("slot_selected", self, "slot_select", [node.slot_save_data])


func populate_menu():
	save_arr = SaveAndLoad.get_all_saves_arr()
	
	for save in save_arr:
		var slot = save_slot.instance()
		slot.populate_slot(save)
		
		save_container.add_child(slot)


func slot_select(save_data):
	selected_save_data = save_data
	
	play_button.disabled = false
	delete_button.disabled = false


func _on_PlayButton_pressed():
	SaveAndLoad.load_save(selected_save_data.filename)
	Global.start_game()


func _on_DeleteButton_pressed():
	# Open a popup menu to confirm
	
	# Connect to SaveAndLoad to remove the file
	
	# Remove the slot from the menu (Refresh the menu?)
	pass # Replace with function body.
