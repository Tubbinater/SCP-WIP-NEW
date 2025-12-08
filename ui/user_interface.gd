extends CanvasLayer


# Date
@onready var date_label: Label = $Top_Panel/DateLabel

func update_date_label(date): #fired from main script
	date_label.text = str(date)
























#
