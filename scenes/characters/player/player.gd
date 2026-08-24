class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	print("[3. PLAYER_STATE] _ready() called | Inspector current_tool: %s" % _get_tool_name(current_tool))

func on_tool_selected(tool: DataTypes.Tools) -> void:
	var old_tool: DataTypes.Tools = current_tool
	current_tool = tool
	hit_component.current_tool = tool
	print("[3. PLAYER_STATE] on_tool_selected() received | Old: %s -> New: %s" % [_get_tool_name(old_tool), _get_tool_name(current_tool)])

func _get_tool_name(tool: DataTypes.Tools) -> String:
	return DataTypes.Tools.keys()[tool] if tool < DataTypes.Tools.size() else "Unknown"
