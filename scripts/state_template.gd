extends Node
class_name State

var id:int
var state_name:String
var	provinces:Array

func set_state_owner(tag): # triggered in state importer
	for node in get_children():
		node.set_province_owner(tag) #fires in province template
		
func set_state_controller(tag): # triggered in state importer
	for node in get_children():
		node.set_province_controller(tag) #fires in province template
