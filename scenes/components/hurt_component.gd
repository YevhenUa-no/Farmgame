class_name HurtComponent
extends Area2D

@export var tool : DataTypes.Tools = DataTypes.Tools.None

signal hurt

func _on_area_entered(area: Area2D) -> void:
	print("[HURT] Area entered: %s" % area.name)
	
	var hit_component = area as HitComponent
	
	if hit_component == null:
		print("[HURT] Ignored: Entered area is NOT a HitComponent")
		return
	
	var expected_tool_name: String = DataTypes.Tools.keys()[tool] if tool < DataTypes.Tools.size() else "Unknown"
	var incoming_tool_name: String = DataTypes.Tools.keys()[hit_component.current_tool] if hit_component.current_tool < DataTypes.Tools.size() else "Unknown"
	
	print("[HURT] Tool comparison | Expected (Tree): %s (%d) | Received (HitComponent): %s (%d)" % [
		expected_tool_name, tool,
		incoming_tool_name, hit_component.current_tool
	])
	
	if tool == hit_component.current_tool:
		print("[HURT] Tool MATCH! Emitting hurt signal with damage: %s" % str(hit_component.hit_damage))
		hurt.emit(hit_component.hit_damage)
	else:
		print("[HURT] Tool MISMATCH! Damage blocked.")
