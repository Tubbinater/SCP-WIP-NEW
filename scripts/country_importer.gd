extends Node

#make a folder with country.txt for each country. include name, color, GOI




# create country (tag, name, color, ideology)
func _ready() -> void:
	create_countries("No Name",Color("5f5f5f00"),"GOC")
	create_countries("France",Color("BLUE"),"SCP")
	create_countries("Germany",Color("BLACK"),"SCP")
	create_countries("Italy",Color("WEB_GREEN"),"SCP")
	create_countries("Spain",Color("GOLD"),"SCP")
	create_countries("Norway",Color("DARK_RED"),"SCP")
	create_countries("Sweden",Color("316cffff"),"SCP")
	create_countries("Great Britain",Color("RED"),"SCP")
	create_countries("Greece",Color("CYAN"),"SCP")
	create_countries("Portugal",Color("TEAL"),"SCP")
	create_countries("Austria",Color("MAGENTA"),"SCP")
	create_countries("Poland",Color("PINK"),"GOC")
	create_countries("Czechoslovakia",Color("AQUA"),"GOC")
	create_countries("Hungary",Color("MAROON"),"GOC")
	create_countries("Romania",Color("BROWN"),"GOC")
	create_countries("Bulgaria",Color("DARK_GREEN"),"GOC")
	create_countries("Soviet Union",Color("CRIMSON"),"GOC")
	create_countries("Denmark",Color("9d655dff"),"SCP")
	create_countries("Switzerland",Color("bf0b39ff"),"SCP")
	create_countries("Belgium",Color("bb5711ff"),"SCP")
	create_countries("Yugoslavia",Color("3c39a8ff"),"SCP")
	create_countries("Ireland",Color("1e9028ff"),"SCP")
	create_countries("Netherlands",Color("8fdb00ff"),"SCP")
	create_countries("Albania",Color("cec381ff"),"SCP")
	create_countries("Finland",Color("aa01e7ff"),"SCP")
	
func create_countries(country_name, color, GOI): #creates node under Countries. then sets its global dictionary
	var country:Country = Country.new()
	country.tag = country_name
	country.name = country_name
	country.country_name = country_name
	country.color = color
	country.GOI = GOI
	add_child(country)
	Globals.tag_to_country[country_name] = country #add into array under "country_name", refers to the created country node.
