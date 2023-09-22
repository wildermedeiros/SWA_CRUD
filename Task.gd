extends Button

@export var desc_label: Label
@export var date_label: Label

@onready var parent = get_parent()

func _on_pressed():
	parent.task_on_focus = self
	parent.set_desc_edit(desc_label.text)
	parent.set_date_edit(date_label.text)

func set_desc_label(new_desc):
	desc_label.text = new_desc

func set_date_label(new_date):
	date_label.text = new_date

