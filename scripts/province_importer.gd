extends Node

@onready var color_to_province :Dictionary

func  _ready() -> void:
	generate_provinces()
	
func generate_provinces() -> void:
	print("STARTING TO GENERATE PROVINCES")
	
	var province_file:String = FileAccess.open("res://map/map_data/Provinces.txt", FileAccess.READ).get_as_text()
	var rows:Array = province_file.split("\n")
	for row in rows:
		if row.strip_edges() != "":
			var columns:Array = row.split(";")
			var province_id:int = int(columns[0])
			var province_color:Color = Color(float(columns[1])/255,float(columns[2])/255,float(columns[3])/255)
			var province_type:String = columns[4]
			
			var province:Province = Province.new()
			province.name = str(province_id)
			province.id = province_id
			province.color = province_color
			province.type = province_type
			if province_type == "land":
				province.set_province_owner("NNN")
				province.set_province_controller("NNN")
			
			add_child(province)
			
			color_to_province[province_color] = province
			
