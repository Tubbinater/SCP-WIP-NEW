extends Node

#make a folder with country.txt for each country. include name, color, GOI




# create country (tag, name, color, ideology)
func _ready() -> void:
	create_countries("No Name",Color("5f5f5f00"))
	create_countries("France",Color("BLUE"))
	create_countries("Germany",Color("BLACK"))
	create_countries("Italy",Color("WEB_GREEN"))
	create_countries("Spain",Color("GOLD"))
	create_countries("Norway",Color("DARK_RED"))
	create_countries("Sweden",Color("316cffff"))
	create_countries("Great Britain",Color("RED"))
	create_countries("Greece",Color("CYAN"))
	create_countries("Portugal",Color("TEAL"))
	create_countries("Austria",Color("MAGENTA"))
	create_countries("Poland",Color("PINK"))
	create_countries("Czechoslovakia",Color("AQUA"))
	create_countries("Hungary",Color("MAROON"))
	create_countries("Romania",Color("BROWN"))
	create_countries("Bulgaria",Color("DARK_GREEN"))
	create_countries("Soviet Union",Color("CRIMSON"))
	create_countries("Denmark",Color("9d655dff"))
	create_countries("Switzerland",Color("bf0b39ff"))
	create_countries("Belgium",Color("bb5711ff"))
	create_countries("Yugoslavia",Color("3c39a8ff"))
	create_countries("Ireland",Color("1e9028ff"))
	create_countries("Netherlands",Color("8fdb00ff"))
	create_countries("Albania",Color("cec381ff"))
	create_countries("Finland",Color("aa01e7ff"))
	
func create_countries(country_name, color): #creates node under Countries. then sets its global dictionary
	var country:Country = Country.new()
	country.tag = country_name
	country.name = country_name
	country.country_name = country_name
	country.color = color
	add_child(country)
	Globals.tag_to_country[country_name] = country #add into array under "country_name", refers to the created country node.
