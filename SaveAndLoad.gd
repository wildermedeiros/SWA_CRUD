extends Node

@export var task_list: VBoxContainer

func save_game():
	var save = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data = node.call("save")

		var json_string = JSON.stringify(node_data)

		save.store_line(json_string)
		
func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return 

	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:
		node.queue_free()

	var save = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save.get_position() < save.get_length():
		var json_string = save.get_line()

		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		var node_data = json.get_data()

		var task = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(task)
		task_list.tasks.append(task)
		task.set_desc_label(node_data["desc_label_text"])
		task.set_date_label(node_data["date_label_text"])

#		for i in node_data.keys():
#			if i == "filename" or i == "parent":
#				continue
#			task.set(i, node_data[i])
