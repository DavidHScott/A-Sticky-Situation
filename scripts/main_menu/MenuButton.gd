extends Button

enum ButtonType {
	MOVE_SCENE,
	QUIT,
	NEW_GAME,
}

export(ButtonType) var selected_button_type
export(String) var scene_path_to_load
