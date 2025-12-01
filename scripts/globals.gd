extends Node

#stores all country nodes into an array to be called in script anywhere. NOTE: only calls node, not any country data not within node data.
@onready var tag_to_country : Dictionary



# Upgrades
var Large_fuel_upg: bool = false




var TimeYear : int = 1950
var TimeMonth : int = 1
var TimeDay : int = 1

var DaysPassed : int
