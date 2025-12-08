extends Node3D
@export var province_map:Texture2D

func _on_player_province_selected(coordinates) -> void:
	var province_color = province_map.get_image().get_pixel(coordinates.x*10,coordinates.y*10) #found in player script. reason for x10 scale is due to imnage upsize / downsize in game
	var selected_province = $Provinces.color_to_province[province_color]
	print(selected_province)
	$ProvinceSelected.update_labels(selected_province)
	$NavigationRegion3D/Map.highlight_province(selected_province)
	$ProvinceSelected.set_position(selected_province, coordinates)
	
func _on_states_reparent_provinces(state) -> void: #move province node to state written in state-file (called in states) 
	for province in state.provinces:
		var node_to_move = $Provinces.get_node(province)
		node_to_move.reparent(state)


func _ready() -> void:
	user_interface.update_date_label(str(Global.TimeMonth) + "/" + str(Global.TimeDay) + "/" + str(Global.TimeYear))
	# sets label to correct time on launch


func _on_timer_timeout() -> void:
	update_time_data()

@onready var user_interface: CanvasLayer = $UserInterface

func update_time_data(): #advances time by 1, while also updating the time in database
	var days_in_month = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	
	#date components
	var current_year = Global.TimeYear
	var current_month = Global.TimeMonth
	var current_day = Global.TimeDay
	
	#update date logic
	current_day += 1
	if current_day > days_in_month[current_month - 1]:
		current_day = 1
		current_month += 1
		if current_month > 12:
			current_month = 1
			current_year += 1
	
	#days passed
	Global.DaysPassed += 1
	# update global vars
	Global.TimeDay = current_day
	Global.TimeMonth = current_month
	Global.TimeYear = current_year
	
	#prints new date
	DateLabel = str(Global.TimeMonth) + "/" + str(Global.TimeDay) + "/" + str(Global.TimeYear)
	user_interface.update_date_label(DateLabel)
	print("date: " + DateLabel)
	print("days passed: " + str(Global.DaysPassed))
	
var DateLabel : String
