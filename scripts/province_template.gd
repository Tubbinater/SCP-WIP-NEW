extends Node
class_name Province

var id:int
var color:Color
var type:String
var province_owner:Country 
var province_controller:Country
var position: Vector2 = Vector2(0,0)
var true_position : Vector2 #position saved before x10 - used for unit navigation
var country_name : String

var GOI_occupation : String :  #used in MAP.gd for GOI map mode
	set(value):
		GOI_occupation = value
		match GOI_occupation:
			"SCP":
				GOI_color = Color("DARK_GRAY")
			"GOC":
				GOI_color = Color("BLUE")
			"":
				GOI_color = Color()
var GOI_color : Color # used in var GOI_occupation



#moves province node to specified state node -> fires in country template
func set_province_owner(): #triggered in state_template
	if province_owner: #if already parented, then remove it
		province_owner.remove_province(self)
	#print("country_name: ", country_name)
	#print("tag_to_country keys: ", Global.tag_to_country.keys())
	if Global.tag_to_country.has(country_name):
		province_owner = Global.tag_to_country[country_name]
		province_owner.add_province(self) #found in Country_Template - reparents province to country
	else:
		push_warning("Cannot reparent province due to error in country_name: " + country_name + ", id: " + str(id))
	
#sets controller to specified tag
func set_province_controller(tag): #triggered in state_template
	province_controller = Global.tag_to_country[tag]
