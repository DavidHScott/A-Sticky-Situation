extends "res://scripts/tab_buttons/PageTab.gd"


func _on_MarketTab_pressed():
	Global._game().switch_screen(Global._game().UI_PAGES.MARKET)
