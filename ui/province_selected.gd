extends CanvasLayer
@onready var province_id = $PanelContainer/GridContainer/LabelProvinceID
@onready var province_color = $PanelContainer/GridContainer/ColorPickerProvinceColor
@onready var province_type = $PanelContainer/GridContainer/LabelProvinceType
@onready var province_owner = $PanelContainer/GridContainer/LabelOwner
@onready var province_controller = $PanelContainer/GridContainer/LabelController
@onready var province_state = $PanelContainer/GridContainer/LabelState
@onready var province_position = $PanelContainer/GridContainer/LabelPosition
@onready var country_input: TextEdit = $PanelContainer/GridContainer/LabelOwner/CountryInput
@onready var province_input: TextEdit = $PanelContainer/GridContainer/LabelProvinceType/ProvinceInput


var is_setting_province_position: bool = false
var province_

signal save_provinces

func update_labels(province:Province):
	province_id.text  = str(province.id)
	province_color.color = province.color
	province_type.text = province.type
	province_position.text = str(province.position)
	country_input.text = str(province.country_name)
	province_input.text = str(province.type)
	province_ = province
	if province_type.text == "land":
		province_owner.text = province.province_owner.country_name
		province_controller.text = province.province_owner.country_name
		province_state.text = str(province.get_parent().id)
	else:
		province_owner.text = ""
		province_controller.text = ""
		province_state.text = ""


func _on_button_set_position_button_up() -> void:
	is_setting_province_position = true
	
func set_position(province: Province, coordinates):
	if is_setting_province_position:
		province.position = Vector2(coordinates.x*10, coordinates.y*10) # x10 due to ratio of img to 3d mesh
		is_setting_province_position = false
		update_labels(province)


func _on_button_save_button_up() -> void:
	save_provinces.emit()


func _on_save_name_button_button_up() -> void:
	province_.country_name = country_input.text
	province_.type = province_input.text
	print("Saved as: " + province_.country_name + ", type: " + province_.type)
	


func _on_country_input_mouse_exited() -> void:
	country_input.release_focus()


func _on_country_input_2_mouse_exited() -> void:
	province_input.release_focus()
