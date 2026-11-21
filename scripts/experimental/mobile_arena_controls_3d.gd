extends Control
class_name MobileArenaControls3D

signal action_pressed(action: String)

var movement := Vector2.ZERO
var joystick_touch := -1
var buttons := ["ALVO", "ATK", "ESC", "CURA", "FOR"]

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _joystick_center() -> Vector2:
	return Vector2(115.0, size.y - 125.0)

func _button_center(action: String) -> Vector2:
	match action:
		"ATK": return Vector2(size.x - 115.0, size.y - 120.0)
		"ESC": return Vector2(size.x - 290.0, size.y - 190.0)
		"CURA": return Vector2(size.x - 215.0, size.y - 270.0)
		"FOR": return Vector2(size.x - 120.0, size.y - 300.0)
		_: return Vector2(size.x - 355.0, size.y - 90.0)

func _button_radius(action: String) -> float:
	return 60.0 if action == "ATK" else 40.0

func _draw() -> void:
	var center := _joystick_center()
	draw_circle(center, 82.0, Color(0.05, 0.08, 0.12, 0.42))
	draw_arc(center, 82.0, 0.0, TAU, 40, Color(0.8, 0.89, 0.96, 0.75), 3.0)
	draw_circle(center + movement * 52.0, 34.0, Color(0.56, 0.76, 0.93, 0.72))
	for action in buttons:
		var point := _button_center(action)
		var radius := _button_radius(action)
		var fill := Color(0.32, 0.46, 0.69, 0.78) if action == "ATK" else Color(0.09, 0.13, 0.2, 0.72)
		draw_circle(point, radius, fill)
		draw_arc(point, radius, 0.0, TAU, 32, Color(0.89, 0.78, 0.42, 0.9), 3.0)
		var font := ThemeDB.fallback_font
		var text_size := font.get_string_size(action, HORIZONTAL_ALIGNMENT_LEFT, -1, 18)
		draw_string(font, point - Vector2(text_size.x * 0.5, -6.0), action, HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color.WHITE)

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.distance_to(_joystick_center()) <= 105.0 and joystick_touch < 0:
				joystick_touch = event.index
				_set_joystick(event.position)
				get_viewport().set_input_as_handled()
				return
			for action in buttons:
				if event.position.distance_to(_button_center(action)) <= _button_radius(action):
					action_pressed.emit(action)
					get_viewport().set_input_as_handled()
					return
		elif event.index == joystick_touch:
			joystick_touch = -1
			movement = Vector2.ZERO
			queue_redraw()
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag and event.index == joystick_touch:
		_set_joystick(event.position)
		get_viewport().set_input_as_handled()

func _set_joystick(point: Vector2) -> void:
	movement = ((point - _joystick_center()) / 70.0).limit_length(1.0)
	queue_redraw()
