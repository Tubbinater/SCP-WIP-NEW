extends MarginContainer


var menu_options := {} #dictionary of options on menu

func load_options(path: String) -> Dictionary: #load single JSON file, returns in dictionary format
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		return JSON.parse_string(file.get_as_text())
	push_error("Failed to open file: %s" % path)
	file.close()
	return {}
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	menu_options = load_options("res://C_Persistent_Data/Options.json")
	
	# sets value at saved options
	_on_general_volume_value_changed(menu_options["GeneralVolume"])
	_on_music_volume_value_changed(menu_options["MusicVolume"])
	_on_mute_check_box_toggled(menu_options["Mute"])
	_on_resolution_select_item_selected(menu_options["Resolution"])
	_on_fullscreen_item_selected(menu_options["Display"])
	# sets visuals at saved options
	$VBoxContainer/TabContainer/Graphics/MarginContainer2/VBoxContainer/Fullscreen.select(menu_options.Display)
	$VBoxContainer/TabContainer/Graphics/MarginContainer2/VBoxContainer/ResolutionSelect.select(menu_options.Resolution)
	$VBoxContainer/TabContainer/Sound/MarginContainer/VBoxContainer/MuteCheckBox.set_pressed(menu_options.Mute)
	$VBoxContainer/TabContainer/Sound/MarginContainer/VBoxContainer/GeneralVolume.set_value(menu_options.GeneralVolume)
	$VBoxContainer/TabContainer/Sound/MarginContainer/VBoxContainer/MusicVolume.set_value(menu_options.MusicVolume)
	

# general volume
func _on_general_volume_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(0, value)

# mute
func _on_mute_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

# music volume
func _on_music_volume_value_changed(value: float) -> void:
	print(menu_options)


# resolutions
func _on_resolution_select_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))
	center_window()

func _on_fullscreen_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	center_window()


func center_window():
	var screen_center = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size /2)
