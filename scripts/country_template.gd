extends Node

class_name Country

var tag:String
var country_name:String
var color:Color
var ideology:String:
	set(value):
		ideology = value
		match ideology:
			"Democratic":
				ideology_color = Color("BLUE")
			"Communist":
				ideology_color = Color("RED")
var ideology_color:Color
