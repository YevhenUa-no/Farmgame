extends CanvasLayer

func _ready():
	if not OS.has_feature("mobile") and not OS.has_feature("web"):
		# Hide on desktop unless we are testing
		# You can comment this out for testing on desktop
		visible = false

func create_button(name: String, action: String, pos: Vector2, size: Vector2, color: Color, parent: Control):
	var btn = Control.new()
	btn.name = name
	btn.position = pos
	btn.size = size
	btn.gui_input.connect(_on_button_gui_input.bind(btn, action))
	
	# Draw background
	var color_rect = ColorRect.new()
	color_rect.color = color
	color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	btn.add_child(color_rect)
	
	# Draw label
	var label = Label.new()
	label.text = name
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_color_override("font_color", Color.WHITE)
	btn.add_child(label)
	
	parent.add_child(btn)

func _on_button_gui_input(event: InputEvent, btn: Control, action: String):
	if event is InputEventScreenTouch or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		if event.is_pressed():
			Input.action_press(action)
			btn.modulate = Color(0.5, 0.5, 0.5)
		else:
			Input.action_release(action)
			btn.modulate = Color.WHITE

func _enter_tree():
	var dpad = Control.new()
	dpad.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	dpad.position = Vector2(20, -220)
	add_child(dpad)
	
	var btn_size = Vector2(60, 60)
	var c = Color(0.2, 0.2, 0.2, 0.6)
	create_button("W", "walk_up", Vector2(70, 0), btn_size, c, dpad)
	create_button("S", "walk_down", Vector2(70, 140), btn_size, c, dpad)
	create_button("A", "walk_left", Vector2(0, 70), btn_size, c, dpad)
	create_button("D", "walk_right", Vector2(140, 70), btn_size, c, dpad)
	
	var actions = Control.new()
	actions.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	actions.position = Vector2(-220, -220)
	add_child(actions)
	
	create_button("Hit", "hit", Vector2(0, 70), Vector2(70, 70), Color(0.6, 0.2, 0.2, 0.6), actions)
	create_button("Drop", "release_tool", Vector2(90, 0), Vector2(70, 70), Color(0.2, 0.6, 0.2, 0.6), actions)
	create_button("Dirt", "remove_dirt", Vector2(90, 140), Vector2(70, 70), Color(0.2, 0.2, 0.6, 0.6), actions)
