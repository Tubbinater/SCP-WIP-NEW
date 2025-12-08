extends Node
class_name GameData

# C:\Users\DON\AppData\Roaming\Godot\app_userdata\Open Grand Strategy - PCS

var SCP := {} #dictionary of SCPs **MOVE TO GLOBAL

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
		




const template_data_folder = "res://C_Template_Data/"

const current_game_folder = "user://SCP_Foundations_current_game_data/"
const save_folder = "user://SCP_Foundations_saved_game_data/"


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
	
const options_template = "res://C_persist_data/Options.json"
const options_ = "user://Options.json"

func create_new_options(): #creates a saved options file to remember. creates one from template if none is there.
	var check_exists = FileAccess.open(options_, FileAccess.READ)
	if !check_exists:
		var from := FileAccess.open(options_template, FileAccess.READ)
		if from:
			var data = from.get_buffer(from.get_length())
			var to = FileAccess.open(options_, FileAccess.WRITE)
			to.store_buffer(data)
			
			to.close()
			from.close()
	else:
		print("found option settings: " + str(options_))


func save_game(): #only @export var will be saved / loaded in godot
	var saved_game:SavedGame = SavedGame.new()
	
	#NOTE: insert saved variables here
	saved_game.current_year = Global.TimeYear
	saved_game.current_month = Global.TimeMonth
	saved_game.current_day = Global.TimeDay
	
	saved_game.TimeSpeed = Global.TimeSpeed
	
	ResourceSaver.save(saved_game, current_game_folder + "saved_game.tres")
	
	copy_folder(current_game_folder, save_folder + "saved_game_name")
