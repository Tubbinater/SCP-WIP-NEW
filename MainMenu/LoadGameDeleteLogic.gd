extends VBoxContainer

@export var loadgamelist : VBoxContainer

# Called when the node enters the scene tree for the first time.
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
			if path.current_is_dir(): #filters out all but folders
				print("Found file: " + file_name)
				
				#Create an X button for the save file
				var button = Button.new()
				button.text = "X"  # Set the button text to the file name
				@warning_ignore("int_as_enum_without_cast", "int_as_enum_without_match")
				button.set_focus_mode(0)
				# Optionally, store the full path in metadata for easy access
				button.set_meta("file_path", file_name)
				
				# Connect the button's "pressed" signal to a custom function
				button.connect("pressed", _on_delete_save_button_pressed.bind(button))
				
				# Add the button as a child to this VBoxContainer
				add_child(button)
				
			file_name = path.get_next()
		path.list_dir_end()
	else:
		print("An error occurred when trying to access the path.")

# Signal handler for when a save button is pressed
func _on_delete_save_button_pressed(button: Button) -> void:
	# Retrieve the file path from the button's metadata
	var file_path = button.get_meta("file_path").split(".", true, 1)
	print("Save file deleted: ", file_path[0])
	
	# deletes save
	# input delete function here
	
	
	# Refresh this list and the load game list after it deletes the save
	refresh_list()
	loadgamelist.refresh_list()
