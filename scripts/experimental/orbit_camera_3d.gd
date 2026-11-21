extends Camera3D
class_name ArenaOrbitCamera3D

@export var target: Node3D
@export var distance := 24.0
@export var min_distance := 6.0
@export var max_distance := 58.0
@export var yaw_degrees := 0.0
@export var pitch_degrees := 42.0
@export var rotation_sensitivity := 0.24
@export var zoom_step := 2.0
@export var follow_speed := 10.0
@export var overview_center := Vector3.ZERO
@export var overview_blend_start := 80.0
@export var overview_blend_end := 420.0

var _dragging_mouse := false
var _touches: Dictionary = {}
var _pinch_distance := 0.0
var _focus := Vector3.ZERO

func _ready() -> void:
	projection = Camera3D.PROJECTION_PERSPECTIVE
	fov = 45.0
	near = 0.1
	far = 900.0
	distance = clampf(distance, min_distance, max_distance)
	pitch_degrees = clampf(pitch_degrees, 15.0, 78.0)
	if is_instance_valid(target):
		_focus = target.global_position + Vector3.UP * 1.0
		_update_transform(1.0)

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	var overview_weight := smoothstep(overview_blend_start, overview_blend_end, distance)
	var desired_focus := (target.global_position + Vector3.UP).lerp(overview_center, overview_weight)
	_focus = _focus.lerp(desired_focus, clampf(delta * follow_speed, 0.0, 1.0))
	_update_transform(delta)

func _update_transform(_delta: float) -> void:
	var yaw := deg_to_rad(yaw_degrees)
	var pitch := deg_to_rad(pitch_degrees)
	var horizontal := cos(pitch) * distance
	var offset := Vector3(sin(yaw) * horizontal, sin(pitch) * distance, cos(yaw) * horizontal)
	global_position = _focus + offset
	look_at(_focus, Vector3.UP)

func orbit_by_pixels(delta_pixels: Vector2) -> void:
	yaw_degrees = fposmod(yaw_degrees - delta_pixels.x * rotation_sensitivity, 360.0)
	pitch_degrees = clampf(pitch_degrees + delta_pixels.y * rotation_sensitivity, 15.0, 78.0)
	_update_transform(0.0)

func zoom_by_steps(steps: float) -> void:
	distance = clampf(distance + steps * maxf(zoom_step, distance * 0.12), min_distance, max_distance)
	_update_transform(0.0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_dragging_mouse = event.pressed
		elif event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_by_steps(-1.0)
		elif event.pressed and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_by_steps(1.0)
	elif event is InputEventMouseMotion and _dragging_mouse:
		orbit_by_pixels(event.relative)
	elif event is InputEventScreenTouch:
		if event.pressed:
			_touches[event.index] = event.position
		else:
			_touches.erase(event.index)
		_pinch_distance = _current_pinch_distance()
	elif event is InputEventScreenDrag:
		if not _touches.has(event.index):
			return
		_touches[event.index] = event.position
		if _touches.size() == 1:
			orbit_by_pixels(event.relative)
		elif _touches.size() == 2:
			var next_distance := _current_pinch_distance()
			if _pinch_distance > 0.0:
				zoom_by_steps((_pinch_distance - next_distance) / 50.0)
			_pinch_distance = next_distance

func _current_pinch_distance() -> float:
	if _touches.size() != 2:
		return 0.0
	var points := _touches.values()
	return (points[0] as Vector2).distance_to(points[1] as Vector2)
