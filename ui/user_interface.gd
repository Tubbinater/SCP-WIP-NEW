extends CanvasLayer

@onready var main : Node = get_parent()


@onready var money_label: Label = $Top_Panel/MoneyLabel
@onready var veil_integrity_label: Label = $Top_Panel/VeilIntegrityLabel
@onready var research_points_label: Label = $Top_Panel/ResearchPointsLabel
@onready var threat_level_label: Label = $Top_Panel/ThreatLevelLabel

# Date
@onready var date_label: Label = $Top_Panel/DateLabel

func update_date_label(date): #fired from main script
	date_label.text = str(date)

func _ready() -> void:
	button_press_logic()
	money_label.text = "$" + format_number_with_commas(Global.Money)


#region ########################## Button logic ###################################################
func _on_pause_button_pressed() -> void: #maybe in future - separate pressing pause on ui from toggle w/ space
	Global.spacebar_toggle_pause = !Global.spacebar_toggle_pause
	
	if Global.spacebar_toggle_pause == true:
		Global.TimeSpeedMEM = Global.TimeSpeed
		
		if Global.TimeSpeedMEM == 0: #bugfix if/whenever MEM retains a 0 "pause"
			Global.TimeSpeedMEM = 1 #set it to 1, so when unpausing, it defaults to speed 1 instead of 0
			
		Global.TimeSpeed = 0
		button_press_logic()
	
	if Global.spacebar_toggle_pause == false:
		Global.TimeSpeed = Global.TimeSpeedMEM
		button_press_logic()
	

func _on_speed_1_button_pressed() -> void:
	Global.TimeSpeed = 1
	button_press_logic()

func _on_speed_2_button_pressed() -> void:
	Global.TimeSpeed = 2
	button_press_logic()

func _on_speed_3_button_pressed() -> void:
	Global.TimeSpeed = 3
	button_press_logic()

func _on_speed_4_button_pressed() -> void:
	Global.TimeSpeed = 4
	button_press_logic()


@onready var pause_button: Button = $Top_Panel/TimeButtonContainer/PauseButton
@onready var speed_1_button: Button = $Top_Panel/TimeButtonContainer/Speed1Button
@onready var speed_2_button: Button = $Top_Panel/TimeButtonContainer/Speed2Button
@onready var speed_3_button: Button = $Top_Panel/TimeButtonContainer/Speed3Button
@onready var speed_4_button: Button = $Top_Panel/TimeButtonContainer/Speed4Button

func button_press_logic():
	if Global.TimeSpeed != 0:
		Global.spacebar_toggle_pause = false
	
	match Global.TimeSpeed:
		0:
			pause_button.button_pressed = true
			speed_1_button.button_pressed = false
			speed_2_button.button_pressed = false
			speed_3_button.button_pressed = false
			speed_4_button.button_pressed = false
			
		1:
			pause_button.button_pressed = false
			speed_1_button.button_pressed = true
			speed_2_button.button_pressed = false
			speed_3_button.button_pressed = false
			speed_4_button.button_pressed = false
			main.timer.wait_time = 1.2
		2:
			pause_button.button_pressed = false
			speed_1_button.button_pressed = false
			speed_2_button.button_pressed = true
			speed_3_button.button_pressed = false
			speed_4_button.button_pressed = false
			main.timer.wait_time = 0.6
		3:
			pause_button.button_pressed = false
			speed_1_button.button_pressed = false
			speed_2_button.button_pressed = false
			speed_3_button.button_pressed = true
			speed_4_button.button_pressed = false
			main.timer.wait_time = 0.25
		4:
			pause_button.button_pressed = false
			speed_1_button.button_pressed = false
			speed_2_button.button_pressed = false
			speed_3_button.button_pressed = false
			speed_4_button.button_pressed = true
			main.timer.wait_time = 0.15
	
	print("set time speed to: " + str(Global.TimeSpeed))

#endregion #########################################################################################

func format_number_with_commas(number: int) -> String:
	var str_number := str(number)
	var result := ""
	var length := str_number.length()
	
	for i in range(length):
		if i > 0 and (length - i) % 3 == 0:
			result += "," # Add comma
		result += str_number[i]
		
	return result
