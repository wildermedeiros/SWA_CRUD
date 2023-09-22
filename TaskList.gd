extends VBoxContainer

@export var save_load_script: CanvasLayer
@export var delete_button: Button
@export var edit_button: Button
@export var task_scene: PackedScene
@export var desc_edit: TextEdit
@export var date_edit: TextEdit

var tasks = []
var task_on_focus = null:
	get: return task_on_focus
	set(value): 
		task_on_focus = value
		#emit task_on_focus change
		
func _ready():
	save_load_script.load_game()
	
func _process(delta):
	#Melhorar isso aqui, talvez colocar em um evento, quando há mudança no task_on_focus
	delete_button.disabled = task_on_focus == null
	edit_button.disabled = task_on_focus == null

func _on_delete_task():
	if task_on_focus != null:
		var node_path = task_on_focus.get_path()
		var node_to_delete = get_node(node_path)
		if tasks.has(node_to_delete):
			tasks.erase(node_to_delete)
			node_to_delete.queue_free()
			clear_edit_texts()
			save_load_script.save_game()

func _on_create_task_button_down():
	var task = task_scene.instantiate()
	update_task_label(task)
	clear_edit_texts()
	tasks.append(task)
	add_child(task)
	save_load_script.save_game()

func _on_edit_task_button():
	if task_on_focus != null:
		var task_path = task_on_focus.get_path()
		var task_to_edit = get_node(task_path)
		update_task_label(task_to_edit)
		clear_edit_texts()
		task_on_focus = null
		save_load_script.save_game()

func update_task_label(task):
	task.set_desc_label(desc_edit.text)
	task.set_date_label(date_edit.text)
		
func set_desc_edit(new_text):
	desc_edit.text = new_text

func set_date_edit(new_text):
	date_edit.text = new_text

func clear_edit_texts():
	desc_edit.text = ""
	date_edit.text = ""
