extends VBoxContainer

@export var delete_button: Button
@export var edit_button: Button
@export var task_scene: PackedScene

var tasks = []
var task_on_focus = null:
	get: return task_on_focus
	set(value): 
		task_on_focus = value
		#emit task_on_focus change
	
func _process(delta):
	#Melhorar isso aqui, talvez colocar em um evento, quando há mudança no taskonfocus
	delete_button.disabled = task_on_focus == null
	edit_button.disabled = task_on_focus == null

func _on_delete_task():
	if task_on_focus != null:
		var node_path = task_on_focus.get_path()
		var node_to_delete = get_node(node_path)
		if tasks.has(node_to_delete):
			tasks.erase(node_to_delete)
			node_to_delete.queue_free()

func _on_create_task_button_down():
	var task = task_scene.instantiate()
	tasks.append(task)
	add_child(task)

func _on_edit_task_button():
	pass
