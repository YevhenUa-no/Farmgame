class_name SaveLevelDataComponent
extends Node

var level_scene_name: String
var save_game_data_path: String = "user://game_data/"
var save_file_name: String = "save_%s_game_data.tres"
var game_data_resource: SaveGameDataResource


func _ready() -> void:
	add_to_group("save_level_data_component")
	level_scene_name = get_parent().name
	print("[SaveLevelData] 🟢 Initialized for level: '", level_scene_name, "'")


func save_node_data() -> void:
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	print("[SaveLevelData] 🔍 Collecting save data. Found ", nodes.size(), " node(s) in 'save_data_component' group.")
	
	game_data_resource = SaveGameDataResource.new()
	
	if nodes != null:
		for node in nodes:
			if node is SaveDataComponent:
				var save_data_resource: NodeDataResource = node._save_data()
				if save_data_resource == null:
					push_warning("[SaveLevelData] ⚠️ Node '", node.get_parent().name, "' returned null data on _save_data()!")
					continue
				var save_final_resource = save_data_resource.duplicate()
				game_data_resource.save_data_nodes.append(save_final_resource)
				print("[SaveLevelData]  ↳ Saved data for node: ", node.get_parent().name)
			else:
				push_warning("[SaveLevelData] ⚠️ Node in group is not a SaveDataComponent: ", node.name)


func save_game() -> void:
	print("\n--- [SAVE GAME TRIGGERED] ---")
	
	if not DirAccess.dir_exists_absolute(save_game_data_path):
		var dir_err = DirAccess.make_dir_absolute(save_game_data_path)
		print("[SaveLevelData] 📁 Created directory '", save_game_data_path, "'. Result code: ", dir_err)
	
	var level_save_file_name: String = save_file_name % level_scene_name
	var full_path: String = save_game_data_path + level_save_file_name
	
	print("[SaveLevelData] 💾 Saving level '", level_scene_name, "' to: ", full_path)
	
	save_node_data()
	
	print("[SaveLevelData] Total items bundled in resource: ", game_data_resource.save_data_nodes.size())
	
	var result: Error = ResourceSaver.save(game_data_resource, full_path)
	if result == OK:
		print("[SaveLevelData] ✅ SUCCESS: Game saved successfully! (Result: OK / 0)")
	else:
		push_error("[SaveLevelData] ❌ FAILED to save game. Error code: " + str(result) + " (Check error enum)")


func load_game() -> void:
	print("\n--- [LOAD GAME TRIGGERED] ---")
	var level_save_file_name: String = save_file_name % level_scene_name
	var save_game_path: String = save_game_data_path + level_save_file_name
	
	print("[SaveLevelData] Attempting to load file: ", save_game_path)
	
	if not FileAccess.file_exists(save_game_path):
		print("[SaveLevelData] ℹ️ No save file exists at path. Skipping load.")
		return
	
	game_data_resource = ResourceLoader.load(save_game_path)
	
	if game_data_resource == null:
		push_error("[SaveLevelData] ❌ Failed to load resource from: " + save_game_path)
		return
	
	var root_node: Window = get_tree().root
	var count: int = 0
	
	for resource in game_data_resource.save_data_nodes:
		if resource is NodeDataResource:
			resource._load_data(root_node)
			count += 1
			
	print("[SaveLevelData] ✅ SUCCESS: Loaded ", count, " nodes from save file.")
