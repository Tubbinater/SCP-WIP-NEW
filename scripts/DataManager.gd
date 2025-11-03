extends Node
class_name GameData #makes it global

var SCP := {} #dictionary of SCPs

func load_json(path: String) -> Dictionary: #load single JSON file, returns in dictionary format
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		return JSON.parse_string(file.get_as_text()) or {}
	push_error("Failed to open file: %s" % path)
	return {}

func save_json(path: String, data: Dictionary): #saves in dictioanry format
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "\t")) #/t is for format in dictionary (readable)
	else:
		push_error("Failed to save file: %s" % path)

# loads all scps from folder into game
func load_all_scps(folder_path: String = "res://C_Template_Data/SCPs/"):
	var folder1 := DirAccess.open(folder_path)
	if folder1:
		for file_name in folder1.get_files():
			if file_name.ends_with(".json"):
				var path = folder_path + file_name
				var scp_data = load_json(path) #loads single scp file in dict format
				if scp_data.has("id"):
					SCP[scp_data["id"]] = scp_data #create an scp in dictionary, indexed by ID (recalled by ID)
		print("Loaded %d SCPs" % SCP.size())
		




var persistent_data_folder = "res://C_Persistent_Data/"
var template_data_folder = "res://C_Template_Data/"

var current_game_folder = "user://SCP_Foundations_current_game_data/"
var save_folder = "user://SCP_Foundations_saved_game_data/"


func copy_folder(from: String, to: String):
	var path := DirAccess.open(from)
	
	if !path: #debug
		print("'from' folder not found: %s" % from)
	
	# Make sure the destination exists
	DirAccess.make_dir_recursive_absolute(to)
	
	path.list_dir_begin()
	
	var file_name = path.get_next()
	while file_name != "":
		if file_name.begins_with("."): # skips hidden files
			file_name = path.get_next()
			continue
	
		var from_ = from.path_join(file_name)
		var to_ = to.path_join(file_name)
	
		if path.current_is_dir(): # if file is folder, copy whats in the folders
			# run code to copy subfolders
			copy_folder(from_, to_)
		else:
			# Copy files
			var copied_file = FileAccess.open(from_, FileAccess.READ)
			if copied_file:
				var data = copied_file.get_buffer(copied_file.get_length())
				var paste_file = FileAccess.open(to_, FileAccess.WRITE)
				paste_file.store_buffer(data)
				paste_file.close()
				copied_file.close()
		file_name = path.get_next()
	
	path.list_dir_end()
	
	
