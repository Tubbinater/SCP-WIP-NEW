extends Node

class_name Country

var owned_provinces: Array[Province] #used to store current provinces
var map_label: Node2D

#both are triggered in province_template
func add_province(province: Province) -> void:
	owned_provinces.append(province)
	#update array, then save json note

func remove_province(province: Province) -> void:
	owned_provinces.erase(province)
	#delete in array, the save json note

var tag : String
var country_name : String
var color : Color

########### found in province template ######################
#var GOI : String: # This is where you add more ideology (template for more stuff like this.)
	#set(value):
		#GOI = value
		#match GOI:
			#"SCP":
				#GOI_color = Color("DARK_GRAY")
			#"GOC":
				#GOI_color = Color("BLUE")
#var GOI_color : Color # used in var GOI
