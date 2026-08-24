class_name SceneDataResource
extends NodeDataResource

@export var node_name: String
@export var scene_file_path: String


func _save_data(node: Node2D) -> void:
	super._save_data(node)
	node_name = node.name
	scene_file_path = node.scene_file_path


func _load_data(window: Window) -> void:
	if parent_node_path.is_empty() or scene_file_path.is_empty():
		return

	var parent_node: Node = window.get_node_or_null(parent_node_path)
	if parent_node == null:
		return

	if not ResourceLoader.exists(scene_file_path):
		return

	var scene_file_resource = load(scene_file_path) as PackedScene
	if scene_file_resource == null:
		return

	var scene_node = scene_file_resource.instantiate() as Node2D
	if scene_node == null:
		return

	parent_node.add_child(scene_node)
	scene_node.global_position = global_position

	if not node_name.is_empty():
		scene_node.name = node_name
