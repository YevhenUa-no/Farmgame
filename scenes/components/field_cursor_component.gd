class_name FieldCursorComponent
extends Node

@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 3

var player: Player
var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var global_cell_position: Vector2
var distance: float

func _ready() -> void:
	await get_tree().process_frame
	_find_player()

func _find_player() -> bool:
	if is_instance_valid(player):
		return true

	var player_nodes: Array[Node] = get_tree().get_nodes_in_group("player")
	if not player_nodes.is_empty():
		player = player_nodes[0] as Player
		return is_instance_valid(player)
	return false

func _unhandled_input(event: InputEvent) -> void:
	if not _find_player():
		return

	if event.is_action_pressed("remove_dirt"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_tilled_soil_cell()
	elif event.is_action_pressed("hit"):
		if ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			add_tilled_soil_cell()

func get_cell_under_mouse() -> void:
	if not grass_tilemap_layer:
		return

	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	
	var local_pos: Vector2 = grass_tilemap_layer.map_to_local(cell_position)
	global_cell_position = grass_tilemap_layer.to_global(local_pos)
	distance = player.global_position.distance_to(global_cell_position)

func add_tilled_soil_cell() -> void:
	if not tilled_soil_tilemap_layer:
		return

	if distance < 20.0 and cell_source_id != -1:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)

func remove_tilled_soil_cell() -> void:
	if not tilled_soil_tilemap_layer:
		return

	if distance < 20.0:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
