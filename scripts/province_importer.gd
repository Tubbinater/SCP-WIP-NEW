extends Node

@onready var color_to_province :Dictionary

func  _ready() -> void:
	generate_provinces()
	
func generate_provinces() -> void:
	print("STARTING TO GENERATE PROVINCES")
	
	var province_file:String = FileAccess.open("user://SCP_Foundations_current_game_data/map_data/Provinces.txt", FileAccess.READ).get_as_text()
	var rows:Array = province_file.split("\n")
	for row in rows:
		if row.strip_edges() != "":
			var columns:Array = row.split(",")
			var province_id:int = int(columns[0]) # id, r,g,b, "type", x, y
			var province_color:Color = Color(float(columns[1])/255,float(columns[2])/255,float(columns[3])/255)
			var province_type:String = columns[4]
			var province_position: Vector2 = Vector2(float(columns[5]),float(columns[6]))
			var country_owner: String = str(columns[7])
			var province_GOI: String = str(columns[8])
			
			var province:Province = Province.new()
			province.name = str(province_id)
			province.id = province_id
			province.color = province_color
			province.type = province_type
			province.position = province_position
			province.GOI_occupation = province_GOI
			province.true_position = Vector2(province_position.x/10, province_position.y/10)
			
			if province_type == "land": #sets any land not accounted for to default (makes sure it doesn't break map code when calling provinces.
				province.country_name = "No Name"
			if country_owner != "":
				province.country_name = country_owner
			if province_type != "land": #DEBUG / TEMP code -> for changing small province land types into sea.
				province.country_name = ""
			
			add_child(province)
			
			color_to_province[province_color] = province
			
			
func save_provinces_to_file() -> void: #(editor tool to update provinces)
	var province_file = FileAccess.open("res://C_Template_Data/map_data/Provinces.txt", FileAccess.WRITE)
	for province in color_to_province.values():
		var color = province.color
		var line = "%d,%d,%d,%d,%s,%.2f,%.2f,%s,%s" % [
			province.id,
			int(color.r * 255),
			int(color.g * 255),
			int(color.b * 255),
			province.type,
			province.position.x,
			province.position.y,
			province.country_name,
			province.GOI_occupation
		]
		province_file.store_line(line)
	print("Provinces saved successfully!")
	


func _on_province_selected_save_provinces() -> void:
	save_provinces_to_file()
