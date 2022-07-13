extends "res://scripts/tab_buttons/PageTab.gd"


func _on_OrdersTab_pressed():
	Global._game().switch_screen(Global._game().UI_PAGES.ORDERS)
