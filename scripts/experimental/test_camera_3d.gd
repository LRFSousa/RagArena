extends Camera3D
class_name MountainTestCamera3D

var target: Node3D
var overview := false
@export var follow_speed := 6.0
@export var camera_offset := Vector3(0.0, 16.0, 18.0)

func _ready() -> void:
	projection = Camera3D.PROJECTION_ORTHOGONAL
	size = 24.0
	near = 0.1
	far = 100.0

func _process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	var focus := Vector3(0, 2.5, -1) if overview else target.global_position + Vector3.UP * 0.9
	global_position = global_position.lerp(focus + camera_offset, clampf(delta * follow_speed, 0.0, 1.0))
	look_at(focus, Vector3.UP)
