extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var log_scene = preload("res://scenes/object/tree/log.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)
	print("[TREE] Initialized at position %s | HurtComponent expected tool: %s" % [
		global_position,
		DataTypes.Tools.keys()[hurt_component.tool] if hurt_component.tool < DataTypes.Tools.size() else "Unknown"
	])

func on_hurt(hit_damage: int) -> void:
	print("[TREE] on_hurt() triggered | Applying damage: %d" % hit_damage)
	damage_component.apply_damage(hit_damage)
	
	if material != null:
		material.set_shader_parameter("shake_intensity", 0.5)
		await get_tree().create_timer(1.0).timeout
		material.set_shader_parameter("shake_intensity", 0.0)
	else:
		print("[TREE] Warning: No shader material assigned for shake effect.")

func on_max_damage_reached() -> void:
	print("[TREE] on_max_damage_reached() | Tree destroyed, spawning log...")
	call_deferred("add_log_scene")
	queue_free()

func add_log_scene() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
	print("[TREE] Log spawned at: %s" % log_instance.global_position)
