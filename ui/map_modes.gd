extends CanvasLayer
signal map_mode_selected(mode)
enum MapMode {POLITICAL, GOI}

func _on_button_political_button_up() -> void:
	map_mode_selected.emit(MapMode.POLITICAL)



func _on_button_GOI_button_up() -> void:
	map_mode_selected.emit(MapMode.GOI)
