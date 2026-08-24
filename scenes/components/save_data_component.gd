class_name SaveDataComponent
extends Node

@onready var parent_node: Node2D = get_parent() as Node2D

@export var save_data_resource: Resource


func _ready() -> void:
	add_to_group("save_data_component")


func _save_data() -> Resource:
	if parent_node == null:
		push_error("❌ [SaveDataComponent] Parent node is null on: %s" % name)
		return null
	
	if save_data_resource == null:
		push_error("❌ [SaveDataComponent] 'save_data_resource' is not assigned in Inspector on: %s" % parent_node.name)
		return null
	
	save_data_resource._save_data(parent_node)
	
	print("💾 [Saved Node] Node: '%s' | Type: %s | Position: %s" % [
		parent_node.name,
		save_data_resource.get_script().get_global_name() if save_data_resource.get_script() else save_data_resource.get_class(),
		parent_node.global_position
	])
	
	return save_data_resource
