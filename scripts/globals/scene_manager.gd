extends Node

var main_scene_path: String = "res://scenes/main_scene.tscn"
var main_scene_root_path: String = "/root/MainScene"
var main_scene_level_root_path: String = "/root/MainScene/GameRoot/LevelRoot"

var level_scenes: Dictionary = {
	"Level1": "res://scenes/levels/level_1.tscn"
}

func load_main_scene_container() -> void:
	if get_tree().root.has_node(main_scene_root_path):
		return
	
	var scene_res = load(main_scene_path)
	if scene_res == null:
		push_error("[SceneManager] MainScene not found at: " + main_scene_path)
		return
		
	var node: Node = scene_res.instantiate()
	if node != null:
		get_tree().root.add_child(node)

func load_level(level: String) -> void:
	var scene_path: String = level_scenes.get(level)
	if scene_path == null:
		push_error("[SceneManager] Level key not found: " + level)
		return
	
	var scene_res = load(scene_path)
	if scene_res == null:
		push_error("[SceneManager] Level scene not found at: " + scene_path)
		return

	var level_scene: Node = scene_res.instantiate()
	var level_root: Node = get_node_or_null(main_scene_level_root_path)
	
	if level_root != null:
		for node: Node in level_root.get_children():
			node.queue_free()
		
		await get_tree().process_frame
		level_root.add_child(level_scene)
	else:
		push_error("[SceneManager] LevelRoot node not found at: " + main_scene_level_root_path)
