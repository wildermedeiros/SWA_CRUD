extends Button


@onready var parent = get_parent()

func _on_pressed():
	parent.task_on_focus = self
