class_name HitComponent
extends Area2D

@export var current_tool : DataTypes.Tools = DataTypes.Tools.None:
	set(value):
		var old_tool: DataTypes.Tools = current_tool
		current_tool = value
		print("[HIT_COMPONENT] Tool updated | Old: %s -> New: %s" % [
			_get_tool_name(old_tool),
			_get_tool_name(current_tool)
		])

@export var hit_damage : int = 1

func _ready() -> void:
	print("[HIT_COMPONENT] Initialized | Starting tool: %s | Damage: %d | Monitoring: %s" % [
		_get_tool_name(current_tool),
		hit_damage,
		str(monitoring)
	])

func _get_tool_name(tool: DataTypes.Tools) -> String:
	return DataTypes.Tools.keys()[tool] if tool < DataTypes.Tools.size() else "Unknown"
