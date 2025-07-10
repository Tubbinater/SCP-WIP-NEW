extends Node
class_name Province

var id:int
var color:Color
var type:String
var province_owner:Country 
var province_controller:Country

func set_province_owner(tag):
	province_owner = Globals.tag_to_country[tag]
	
func set_province_controller(tag):
	province_controller = Globals.tag_to_country[tag]
