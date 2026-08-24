class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer

var player: Player

var corn_plant_scene = preload("res://scenes/object/plants/сorn.tscn")
var tomato_plant_scene = preload("res://scenes/object/plants/tomato.tscn")

var cell_position: Vector2i
var cell_source_id: int
var global_cell_position: Vector2
var distance: float 

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	print("[CropsCursor] Initialized. Player detected: ", player != null)
	
	if not tilled_soil_tilemap_layer:
		push_error("[CropsCursor] ❌ 'tilled_soil_tilemap_layer' is NOT assigned in the Inspector!")

func _unhandled_input(event: InputEvent) -> void:
	if not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		if not is_instance_valid(player):
			return

	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_crop()
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
			get_cell_under_mouse()
			add_crop()

func get_cell_under_mouse() -> void:
	if not tilled_soil_tilemap_layer or not player:
		return

	# Use global mouse coordinate converted to layer's local space
	var global_mouse_pos: Vector2 = tilled_soil_tilemap_layer.get_global_mouse_position()
	var layer_local_mouse: Vector2 = tilled_soil_tilemap_layer.to_local(global_mouse_pos)
	
	# Convert to grid coordinate
	cell_position = tilled_soil_tilemap_layer.local_to_map(layer_local_mouse)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	
	# Get world center of that specific cell
	var local_tile_center: Vector2 = tilled_soil_tilemap_layer.map_to_local(cell_position)
	global_cell_position = tilled_soil_tilemap_layer.to_global(local_tile_center)
	
	distance = player.global_position.distance_to(global_cell_position)
	print("[CropsCursor] Mouse at Global: ", snappedf(global_mouse_pos.x, 0.1), ",", snappedf(global_mouse_pos.y, 0.1), " -> Cell: ", cell_position, " -> Spawn Pos: ", global_cell_position, " | Dist: ", snappedf(distance, 0.1))

func add_crop() -> void:
	if distance >= 20.0:
		print("[CropsCursor] ❌ Plant failed: Distance too far (", snappedf(distance, 0.1), " >= 20.0)")
		return

	if cell_source_id == -1:
		print("[CropsCursor] ❌ Plant failed: No tilled soil at cell ", cell_position)
		return

	var crop_fields_container = get_parent().find_child("CropFields", true, false)
	if not crop_fields_container:
		push_error("[CropsCursor] ❌ Plant failed: 'CropFields' container not found under ", get_parent().name)
		return

	for crop: Node2D in crop_fields_container.get_children():
		if crop.global_position.distance_to(global_cell_position) < 2.0:
			print("[CropsCursor] ❌ Plant failed: Crop already exists at ", global_cell_position)
			return

	var crop_instance: Node2D = null
	var crop_name: String = ""

	if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
		crop_instance = corn_plant_scene.instantiate() as Node2D
		crop_name = "Corn"
	elif ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
		crop_instance = tomato_plant_scene.instantiate() as Node2D
		crop_name = "Tomato"

	if crop_instance:
		crop_fields_container.add_child(crop_instance)
		crop_instance.global_position = global_cell_position
		print("🌱 [CropsCursor] SUCCESS: Planted ", crop_name, " at Global Position: ", global_cell_position, " (Cell: ", cell_position, ")")

func remove_crop() -> void:
	if distance < 20.0:
		var crop_container = get_parent().find_child("CropFields", true, false)
		if not crop_container:
			return
		
		for node: Node2D in crop_container.get_children():
			if node.global_position.distance_to(global_cell_position) < 2.0:
				print("🗑️ [CropsCursor] Removed crop: ", node.name, " at ", global_cell_position)
				node.queue_free()
				return
