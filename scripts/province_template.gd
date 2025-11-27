extends Node
class_name Province

var id:int
var color:Color
var type:String
var province_owner:Country 
var province_controller:Country
var position: Vector2 = Vector2(0,0)
var true_position : Vector2
var country_name : String

#moves province node to specified state node -> fires in country template
func set_province_owner(): #triggered in state_template
	if province_owner: #if already parented, then remove it
		province_owner.remove_province(self)
	#print("country_name: ", country_name)
	#print("tag_to_country keys: ", Globals.tag_to_country.keys())
	if Globals.tag_to_country.has(country_name):
		province_owner = Globals.tag_to_country[country_name]
		province_owner.add_province(self) #found in Country_Template - reparents province to country
	else:
		push_warning("Cannot reparent province due to error in country_name: " + country_name)
	
#sets controller to specified tag
func set_province_controller(tag): #triggered in state_template
	province_controller = Globals.tag_to_country[tag]
