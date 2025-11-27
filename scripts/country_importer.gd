extends Node

# create country (tag, name, color, ideology)
func _ready() -> void:
	create_countries("No Name",Color("5f5f5f00"),"Communist")
	create_countries("France",Color("BLUE"),"Democratic")
	create_countries("Germany",Color("BLACK"),"Democratic")
	create_countries("Italy",Color("WEB_GREEN"),"Democratic")
	create_countries("Spain",Color("GOLD"),"Democratic")
	create_countries("Norway",Color("DARK_RED"),"Democratic")
	create_countries("Sweden",Color("316cffff"),"Democratic")
	create_countries("Great Britain",Color("RED"),"Democratic")
	create_countries("Greece",Color("CYAN"),"Democratic")
	create_countries("Portugal",Color("TEAL"),"Democratic")
	create_countries("Austria",Color("MAGENTA"),"Democratic")
	create_countries("Poland",Color("PINK"),"Communist")
	create_countries("Czechoslovakia",Color("AQUA"),"Communist")
	create_countries("Hungary",Color("MAROON"),"Communist")
	create_countries("Romania",Color("BROWN"),"Communist")
	create_countries("Bulgaria",Color("DARK_GREEN"),"Communist")
	create_countries("Soviet Union",Color("CRIMSON"),"Communist")
	create_countries("Denmark",Color("9d655dff"),"Democratic")
	create_countries("Switzerland",Color("bf0b39ff"),"Democratic")
	create_countries("Belgium",Color("bb5711ff"),"Democratic")
	create_countries("Yugoslavia",Color("3c39a8ff"),"Democratic")
	create_countries("Ireland",Color("1e9028ff"),"Democratic")
	create_countries("Netherlands",Color("8fdb00ff"),"Democratic")
	create_countries("Albania",Color("cec381ff"),"Democratic")
	create_countries("Finland",Color("aa01e7ff"),"Democratic")
	
func create_countries(country_name, color, ideology): #creates node under Countries. then sets its global dictionary
	var country:Country = Country.new()
	country.tag = country_name
	country.name = country_name
	country.country_name = country_name
	country.color = color
	country.ideology = ideology
	add_child(country)
	Globals.tag_to_country[country_name] = country #add into array under "country_name", refers to the created country node.
