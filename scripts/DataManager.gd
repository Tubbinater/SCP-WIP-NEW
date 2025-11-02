extends Node
class_name Data #makes it global

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
