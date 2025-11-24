extends Control


@export var options : MarginContainer
@export var LoadGameBox : MarginContainer
@export var CreditBox : MarginContainer

const credits_txt_path = "res://MainMenu/Credits.txt"
@export var credits_label: RichTextLabel

@export var gamebuttonbox : VBoxContainer


func _ready() -> void:
	var txt_file = FileAccess.open(credits_txt_path, FileAccess.READ)
	var text = txt_file.get_as_text()
	txt_file.close()
	if text!= null:
		credits_label.text = text
		print("Credits loaded Succesfully")
	else:
		print("Credits failed to load")
	
	


func _on_new_game_button_pressed() -> void:
	# new game file created from base template file
	DataManager.copy_folder(DataManager.template_data_folder,DataManager.current_game_folder)
	
	
	get_tree().change_scene_to_file("res://levels/main.tscn") #opens the game system, where it will pull all the global vars


func _on_load_game_button_pressed() -> void:
	gamebuttonbox.refresh_list()
	LoadGameBox.set_visible(!LoadGameBox.is_visible())


func _on_options_button_pressed() -> void:
	options.set_visible(!options.is_visible())


func _on_credits_button_pressed() -> void:
	CreditBox.set_visible(!CreditBox.is_visible())
	
	DataManager.copy_folder(DataManager.current_game_folder,DataManager.save_folder + "save1")


func _on_exit_game_button_pressed() -> void:
	get_tree().quit()
