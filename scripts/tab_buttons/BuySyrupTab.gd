extends "res://scripts/tab_buttons/PageTab.gd"


func _on_BuySyrupTab_pressed():
	Global._game().switch_screen(Global._game().UI_PAGES.BUY_SYRUP)
