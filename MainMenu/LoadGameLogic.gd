extends VBoxContainer



func _ready() -> void:
	refresh_list()

const SAVE_FOLDER = DataManager.save_folder




func refresh_list(): #creates a list of buttons per save file
	for button in get_children(): #deletes list before making new one
		if button is Button:
			remove_child(button)
	var path = DirAccess.open(SAVE_FOLDER)
	if path:
		path.list_dir_begin() #list files
		var file_name = path.get_next()
		
		while file_name != "":
			if path.current_is_dir(): #filters only folders and only leaves everything else out
				
				#Create a button for the save file
				var button = Button.new()
				button.text = file_name # Set the button text to the file name
				@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
				button.set_focus_mode(0)
				# store the full path in metadata for easy access (can delete if not worth it)
				button.set_meta("file_path", file_name)
				
				# Connect the button's "pressed" signal to a custom function
				button.connect("pressed", _on_load_save_button_pressed.bind(button))
				
				# Add the button as a child to this VBoxContainer
				add_child(button)
				
			file_name = path.get_next()
		path.list_dir_end()
	else:
		print("An error occurred when trying to access the path: %s." % SAVE_FOLDER)
	

# Signal handler for when a save button is pressed
func _on_load_save_button_pressed(button: Button) -> void:
	# Retrieve the file path from the button's metadata
	var file_path = button.get_meta("file_path")
	print("Save file selected: ", file_path)
	
	#load the selected save file and run game
	DataManager.copy_folder(DataManager.save_folder + file_path , DataManager.current_game_folder)
	Global.refresh_saved_game_data()
	
	get_tree().change_scene_to_file("res://levels/main.tscn")
