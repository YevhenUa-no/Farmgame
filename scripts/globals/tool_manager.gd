extends Node

var selected_tool: DataTypes.Tools = DataTypes.Tools.None

signal tool_selected(tool: DataTypes.Tools)
signal enable_tool(tool: DataTypes.Tools)

func _ready() -> void:
	print("[2. TOOL_MANAGER] Initialized | Default selected_tool: %s" % _get_tool_name(selected_tool))

func select_tool(tool: DataTypes.Tools) -> void:
	var old_tool: DataTypes.Tools = selected_tool
	var source: String = "Default/Clear" if tool == DataTypes.Tools.None else "Panel/External"
	
	print("[2. TOOL_MANAGER] select_tool() | Old: %s -> New: %s | Source: %s" % [
		_get_tool_name(old_tool),
		_get_tool_name(tool),
		source
	])
	
	selected_tool = tool
	
	print("[2. TOOL_MANAGER] Emitting 'tool_selected' signal | Value: %s (ID: %d)" % [_get_tool_name(tool), tool])
	tool_selected.emit(tool)

func enable_tool_button(tool: DataTypes.Tools) -> void:
	print("[2. TOOL_MANAGER] enable_tool_button() | Unlocking: %s" % _get_tool_name(tool))
	enable_tool.emit(tool)

func _get_tool_name(tool: DataTypes.Tools) -> String:
	return DataTypes.Tools.keys()[tool] if tool < DataTypes.Tools.size() else "Unknown"
