extends Node


@export var saved_game_data : SavedGame = load(DataManager.template_data_folder + "saved_game.tres") as SavedGame

#stores all country nodes into an array to be called in script anywhere. NOTE: only calls node, not any country data not within node data.
@onready var tag_to_country : Dictionary



func _ready() -> void:
	if saved_game_data:
		print("saved data is readable")
	else:
		print("no saved data found")

func refresh_saved_game_data(): #only fired when loading a new / saved game
	saved_game_data = load(DataManager.current_game_folder + "saved_game.tres") as SavedGame
	if saved_game_data:
		print("saved data is readable")
	else:
		print("no saved data found")
	
	#NOTE: INPUT ALL VARIABLES AND SET THEM TO saved_game_data variables (inversed in DataManager)
	
	TimeYear = saved_game_data.current_year
	TimeMonth = saved_game_data.current_month
	TimeDay = saved_game_data.current_day
	
	TimeSpeed = saved_game_data.TimeSpeed
	
# Upgrades
var Large_fuel_upg: bool = false




var TimeYear : int
var TimeMonth : int
var TimeDay : int

var DaysPassed : int

var TimeSpeed : int = 0
var TimeSpeedMEM : int = 1 #does not need to be saved, used for space toggle
var spacebar_toggle_pause : bool = true # also no save, same as above
