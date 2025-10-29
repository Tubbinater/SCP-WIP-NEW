extends StaticBody3D

@onready var province_color_to_lookup : Dictionary
@onready var map_material_2d = load("res://map/shaders/map2D.tres")
@onready var color_map_political:Image = Image.create(256,256,false,Image.FORMAT_RGB8)
@onready var color_map_ideology:Image = Image.create(256,256,false,Image.FORMAT_RGB8)

var current_map_mode:Image
var color_map_texture:ImageTexture

var previously_selected_provinces :PackedColorArray

enum MapMode {POLITICAL, IDEOLOGY}

func _ready() -> void:
	create_lookup_texture()
	create_color_map()
	set_map_mode_political()
	create_country_labels()
	
func create_lookup_texture() -> void:
	var province_image : Image = get_parent().province_map.get_image()
	var lookup_image: Image = province_image.duplicate()
	var color_map_r : int = 0
	var color_map_g : int = 0
	
	for x in range(lookup_image.get_width()):
		for y in range(lookup_image.get_height()):
			var province_color : Color = province_image.get_pixel(x,y)
			if not province_color_to_lookup.has(province_color):
				province_color_to_lookup[province_color] = Color(color_map_r/255.0, color_map_g/255.0, 0.0)
				color_map_r += 1
				if color_map_r == 256:
					color_map_r = 0
					color_map_g += 1
			lookup_image.set_pixel(x,y,province_color_to_lookup[province_color])
	var lookup_texture = ImageTexture.create_from_image(lookup_image)
	map_material_2d.set_shader_parameter("lookup_image", lookup_texture)
	
func create_color_map() -> void:
	for province_color :Color in province_color_to_lookup:
		var lookup = province_color_to_lookup[province_color]
		var x = lookup.r * 255
		var y = lookup.g * 255
		var province:Province = get_parent().get_node("Provinces").color_to_province.get(province_color)
		if province.type == "land":
			var owner_color :Color = province.province_owner.color
			var controller_color :Color = province.province_controller.color
			color_map_political.set_pixel(x,y,owner_color)
			color_map_political.set_pixel(x,y+100,controller_color)
			var owner_ideology_color :Color = province.province_owner.ideology_color
			var controller_ideology_color :Color = province.province_controller.ideology_color
			color_map_ideology.set_pixel(x,y,owner_ideology_color)
			color_map_ideology.set_pixel(x,y+100,controller_ideology_color)

# updates color of province and state selected
func update_color_map(input_color:Color, output_color:Color, offset:int) -> void:
	var lookup = province_color_to_lookup.get(input_color,null)
	if lookup:
		var x = lookup.r * 255
		var y = lookup.g * 255
		color_map_political.set_pixel(x,y+offset,output_color)
		color_map_ideology.set_pixel(x,y+offset,output_color)
		current_map_mode.set_pixel(x,y+offset,output_color)
	
	
func update_map_shader() -> void: #colors of entire map is updated to reflect what player wants to filter through
	color_map_texture = ImageTexture.create_from_image(current_map_mode)
	map_material_2d.set_shader_parameter("color_map_image",color_map_texture) #changes shader to updated version

func set_map_mode_political() -> void: #updates map shader for colors
	current_map_mode = color_map_political
	if memory_selected: #if there is memory (if not, skip)
		highlight_province(memory_selected) #re-highlights, to make it align with map view when switched
	update_map_shader()

func set_map_mode_ideology() -> void: # updates map shaders for colors
	current_map_mode = color_map_ideology
	if memory_selected:
		highlight_province(memory_selected)
	update_map_shader()


# Brightens a color by increasing its RGB values proportionally
func brighten_color(color: Color, divider: float = 4) -> Color:
	var r = min(color.r + ((1 - color.r)/divider), 1.0)
	var g = min(color.g + ((1 - color.g)/divider), 1.0)
	var b = min(color.b + ((1 - color.b)/divider), 1.0)
	return Color(r, g, b, color.a)

var memory_selected # store what is selected when changing map view

func highlight_province(selected_province) -> void:
	deselect_provinces()
	if selected_province.type == "land":
		memory_selected = selected_province #stores memory
		for province in selected_province.get_parent().get_children():
			var lookup = province_color_to_lookup.get(province.color, null)
			if lookup:
				var x = lookup.r * 255
				var y = lookup.g * 255
				var base_color = current_map_mode.get_pixel(x, y + 100)
				var brightened = brighten_color(base_color)
				update_color_map(province.color, brightened, 200) # sets state color when clicking children province
				previously_selected_provinces.append(province.color)
			
	var lookup_p = province_color_to_lookup.get(selected_province.color, null)
	if lookup_p:
		var x_p = lookup_p.r * 255
		var y_p = lookup_p.g * 255
		var base_color_p = current_map_mode.get_pixel(x_p, y_p + 100)
		var brightened_p = brighten_color(base_color_p, 2)
	
		update_color_map(selected_province.color, brightened_p, 200) # sets province color when clicked
		update_map_shader()
		previously_selected_provinces.append(selected_province.color)

func deselect_provinces() -> void: #sets color to black when deselects (fires before highlighting again) ***make sure to add esc function to deselect too***
	for color in previously_selected_provinces:
		update_color_map(color, Color("BLACK"), 200)
	previously_selected_provinces.clear()


func _on_map_modes_map_mode_selected(mode: Variant) -> void:
	match mode:
		MapMode.POLITICAL:
			set_map_mode_political()
		MapMode.IDEOLOGY:
			set_map_mode_ideology()

func create_country_labels() -> void:
	var country_label_template: PackedScene = load("res://map/country_label_template.tscn")
	for country: Country in Globals.tag_to_country.values():
		var country_label = country_label_template.instantiate()
		country_label.initial_data(country)
		$MeshInstance3D/SubViewport2/CountryLabels.add_child(country_label)
		country_label.update_data(country)
