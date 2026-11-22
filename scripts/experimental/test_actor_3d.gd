extends CharacterBody3D
class_name MountainTestActor3D

const WALK := {
	"right": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_right.png"),
	"left": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_left.png"),
	"up": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_up.png"),
	"down": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_down.png"),
}
const MODEL_3D_PATH := "res://assets/characters/swordsman/Espadachim.glb"
const WALK_MODEL_PATH := "res://assets/characters/swordsman/Espadachim Caminhando.glb"
const ATTACK_MODEL_PATH := "res://assets/characters/swordsman/Espadachim Atacando.glb"
const ATTACK_DURATION := 0.75

@export var speed := 4.0
@export var accept_player_input := true
@export var use_3d_model := false
@export var guard_walkable_edges := false
@export var lock_elevation_level := false
var move_input := Vector2.ZERO
var direction_name := "down"
var sprite: Sprite3D
var walk_time := 0.0
var movement_camera: Camera3D
var model_3d: Node3D
var walk_model_3d: Node3D
var attack_model_3d: Node3D
var walk_skeleton: Skeleton3D
var attack_skeleton: Skeleton3D
var walk_base_rotations: Dictionary = {}
var attack_base_rotations: Dictionary = {}
var attack_time_remaining := 0.0
var attack_arc: MeshInstance3D
var locked_floor_height := 0.0
var obstacle_grid: Dictionary = {}
var obstacle_cell_size := 2.0
var ramp_passages: Array[Rect2] = []
var facing_world := Vector3(0, 0, -1)

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	floor_max_angle = deg_to_rad(42.0)
	floor_snap_length = 0.5
	floor_constant_speed = true
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.35
	capsule.height = 1.8
	var collider := CollisionShape3D.new()
	collider.shape = capsule
	collider.position.y = 0.9
	add_child(collider)
	sprite = Sprite3D.new()
	sprite.texture = WALK[direction_name]
	sprite.hframes = 6
	sprite.pixel_size = 0.0135
	sprite.position.y = 0.91
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	add_child(sprite)
	if use_3d_model and (ResourceLoader.exists(WALK_MODEL_PATH) or ResourceLoader.exists(MODEL_3D_PATH)):
		model_3d = Node3D.new()
		model_3d.name = "Espadachim3D"
		model_3d.scale = Vector3.ONE * 2.76
		add_child(model_3d)
		var walk_path := WALK_MODEL_PATH if ResourceLoader.exists(WALK_MODEL_PATH) else MODEL_3D_PATH
		walk_model_3d = (load(walk_path) as PackedScene).instantiate()
		model_3d.add_child(walk_model_3d)
		walk_skeleton = _find_skeleton(walk_model_3d)
		walk_base_rotations = _capture_bone_rotations(walk_skeleton)
		var attack_path := ATTACK_MODEL_PATH if ResourceLoader.exists(ATTACK_MODEL_PATH) else walk_path
		attack_model_3d = (load(attack_path) as PackedScene).instantiate()
		attack_model_3d.hide()
		model_3d.add_child(attack_model_3d)
		attack_skeleton = _find_skeleton(attack_model_3d)
		attack_base_rotations = _capture_bone_rotations(attack_skeleton)
		attack_arc = _build_attack_arc()
		model_3d.add_child(attack_arc)
		# A importacao de modelos animados pode falhar na renderizacao Web.
		# Mantemos o sprite atras do modelo para o personagem continuar visivel.
		if OS.has_feature("web"):
			sprite.position = Vector3(0, 1.35, -0.32)
			sprite.pixel_size = 0.020
		else:
			sprite.hide()

func _physics_process(delta: float) -> void:
	if accept_player_input:
		move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if Input.is_action_just_pressed("attack"):
			start_attack_preview()
	attack_time_remaining = maxf(attack_time_remaining - delta, 0.0)
	var direction := movement_direction(move_input) if attack_time_remaining <= 0.0 else Vector3.ZERO
	if guard_walkable_edges and is_on_floor() and direction.length_squared() > 0.01 and not _has_safe_floor_ahead(direction, delta):
		direction = Vector3.ZERO
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= 9.8 * delta
	move_and_slide()
	if direction.length_squared() > 0.01:
		walk_time += delta
		face_world_direction(direction)
		var next_direction := "right" if absf(move_input.x) >= absf(move_input.y) and move_input.x > 0.0 else "left" if absf(move_input.x) >= absf(move_input.y) else "down" if move_input.y > 0.0 else "up"
		if next_direction != direction_name:
			direction_name = next_direction
			sprite.texture = WALK[direction_name]
		sprite.frame = int(walk_time * 8.0) % 6
	else:
		sprite.frame = 0
	_update_model_animation(delta, direction.length_squared() > 0.01)

func face_world_direction(direction: Vector3) -> void:
	var horizontal := Vector3(direction.x, 0, direction.z)
	if horizontal.length_squared() < 0.001:
		return
	facing_world = horizontal.normalized()
	if model_3d != null:
		model_3d.rotation.y = atan2(facing_world.x, facing_world.z)

func _has_safe_floor_ahead(direction: Vector3, delta: float) -> bool:
	var ahead := global_position + direction * (speed * delta + 0.08)
	if not _can_enter_obstacle_space(ahead):
		return false
	for passage in ramp_passages:
		if passage.has_point(Vector2(ahead.x, ahead.z)):
			return true
	var start := ahead + Vector3.UP * 1.2
	var end := ahead + Vector3.DOWN * 1.8
	var query := PhysicsRayQueryParameters3D.create(start, end, 1 | 4)
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return false
	var floor_y: float = hit.position.y
	if floor_y < global_position.y - 1.1 or floor_y > global_position.y + 0.85:
		return false
	if lock_elevation_level and not _is_designated_bridge(ahead) and absf(floor_y - locked_floor_height) > 0.55:
		return false
	return true

func _is_designated_bridge(point: Vector3) -> bool:
	return point.x >= 10.5 and point.x <= 39.0 and absf(point.z + 11.29) <= 1.1

func _can_enter_obstacle_space(ahead: Vector3) -> bool:
	var cell := Vector2i(floori(ahead.x / obstacle_cell_size), floori(ahead.z / obstacle_cell_size))
	var here := Vector2(global_position.x, global_position.z)
	var next := Vector2(ahead.x, ahead.z)
	for dx in range(-1, 2):
		for dz in range(-1, 2):
			for entry in obstacle_grid.get(cell + Vector2i(dx, dz), []):
				var obstacle: Vector4 = entry
				if absf(obstacle.y - global_position.y) > 1.4:
					continue
				var center := Vector2(obstacle.x, obstacle.z)
				var before := here.distance_to(center)
				var after := next.distance_to(center)
				if after < obstacle.w and after < before - 0.001:
					return false
	return true

func is_clear_of_obstacles() -> bool:
	var cell := Vector2i(floori(global_position.x / obstacle_cell_size), floori(global_position.z / obstacle_cell_size))
	var here := Vector2(global_position.x, global_position.z)
	for dx in range(-1, 2):
		for dz in range(-1, 2):
			for entry in obstacle_grid.get(cell + Vector2i(dx, dz), []):
				var obstacle: Vector4 = entry
				if absf(obstacle.y - global_position.y) <= 1.4 and here.distance_to(Vector2(obstacle.x, obstacle.z)) < obstacle.w:
					return false
	return true

func start_attack_preview() -> void:
	attack_time_remaining = ATTACK_DURATION
	if model_3d != null and attack_model_3d != null:
		walk_model_3d.hide()
		attack_model_3d.show()

func _update_model_animation(_delta: float, moving: bool) -> void:
	if model_3d == null:
		return
	if attack_time_remaining > 0.0:
		if attack_model_3d == null:
			return
		var progress := 1.0 - attack_time_remaining / ATTACK_DURATION
		var swing := sin(progress * PI)
		_pose_bone(attack_skeleton, attack_base_rotations, "mixamorig_LeftArm", Vector3.RIGHT, -1.15)
		_pose_bone(attack_skeleton, attack_base_rotations, "mixamorig_RightArm", Vector3.FORWARD, 1.15 - 2.0 * swing)
		_pose_bone(attack_skeleton, attack_base_rotations, "mixamorig_RightForeArm", Vector3.RIGHT, -0.7 * swing)
		_pose_bone(attack_skeleton, attack_base_rotations, "mixamorig_Spine2", Vector3.UP, -0.28 * swing)
		attack_arc.visible = progress > 0.2 and progress < 0.8
		attack_arc.rotation.y = (progress - 0.5) * 1.2
		return
	if attack_arc != null:
		attack_arc.hide()
	if attack_model_3d != null and attack_model_3d.visible:
		attack_model_3d.hide()
		walk_model_3d.show()
	if walk_skeleton == null:
		return
	var stride := sin(walk_time * 9.0) * 0.34 if moving else 0.0
	# No rig importado, Z é a lateral do corpo. Girar as coxas nesse eixo
	# leva as pernas para frente/trás, sem abri-las para os lados.
	_pose_bone(walk_skeleton, walk_base_rotations, "mixamorig_LeftUpLeg", Vector3.FORWARD, stride)
	_pose_bone(walk_skeleton, walk_base_rotations, "mixamorig_RightUpLeg", Vector3.FORWARD, -stride)
	_pose_walk_arm("mixamorig_LeftArm", -stride * 0.9)
	_pose_walk_arm("mixamorig_RightArm", stride * 0.45)

func _pose_walk_arm(bone_name: String, swing: float) -> void:
	if walk_skeleton == null or not walk_base_rotations.has(bone_name):
		return
	var index := walk_skeleton.find_bone(bone_name)
	var lateral_axis: Vector3 = walk_skeleton.get_bone_global_rest(index).basis.inverse() * Vector3.FORWARD
	var lower_arm := Quaternion(Vector3.FORWARD, 1.15) if bone_name == "mixamorig_RightArm" else Quaternion(Vector3.RIGHT, -1.15)
	var forward_swing := Quaternion(lateral_axis.normalized(), swing)
	walk_skeleton.set_bone_pose_rotation(index, forward_swing * lower_arm * (walk_base_rotations[bone_name] as Quaternion))

func _build_attack_arc() -> MeshInstance3D:
	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(1.0, 0.75, 0.18, 0.78)
	material.emission_enabled = true
	material.emission = Color(1.0, 0.55, 0.05)
	material.emission_energy_multiplier = 1.2
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	var arc_mesh := ImmediateMesh.new()
	arc_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES, material)
	for i in range(20):
		var a0 := -1.2 + 2.4 * float(i) / 20.0
		var a1 := -1.2 + 2.4 * float(i + 1) / 20.0
		var inner0 := Vector3(sin(a0) * 0.62, 0.55, cos(a0) * 0.62)
		var outer0 := Vector3(sin(a0) * 0.78, 0.55, cos(a0) * 0.78)
		var inner1 := Vector3(sin(a1) * 0.62, 0.55, cos(a1) * 0.62)
		var outer1 := Vector3(sin(a1) * 0.78, 0.55, cos(a1) * 0.78)
		arc_mesh.surface_add_vertex(inner0)
		arc_mesh.surface_add_vertex(outer0)
		arc_mesh.surface_add_vertex(inner1)
		arc_mesh.surface_add_vertex(inner1)
		arc_mesh.surface_add_vertex(outer0)
		arc_mesh.surface_add_vertex(outer1)
	arc_mesh.surface_end()
	var arc := MeshInstance3D.new()
	arc.name = "ArcoAtaqueProvisorio"
	arc.mesh = arc_mesh
	arc.hide()
	return arc

func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node
	for child in node.get_children():
		var found := _find_skeleton(child)
		if found != null:
			return found
	return null

func _capture_bone_rotations(skeleton: Skeleton3D) -> Dictionary:
	var rotations := {}
	if skeleton == null:
		return rotations
	for bone_name in ["mixamorig_LeftUpLeg", "mixamorig_RightUpLeg", "mixamorig_LeftArm", "mixamorig_RightArm", "mixamorig_RightForeArm", "mixamorig_Spine2"]:
		var index := skeleton.find_bone(bone_name)
		if index >= 0:
			rotations[bone_name] = skeleton.get_bone_pose_rotation(index)
	return rotations

func _pose_bone(skeleton: Skeleton3D, base_rotations: Dictionary, bone_name: String, axis: Vector3, angle: float) -> void:
	if skeleton == null or not base_rotations.has(bone_name):
		return
	var index := skeleton.find_bone(bone_name)
	skeleton.set_bone_pose_rotation(index, Quaternion(axis, angle) * (base_rotations[bone_name] as Quaternion))

func movement_direction(input_vector: Vector2) -> Vector3:
	if not is_instance_valid(movement_camera):
		return Vector3(input_vector.x, 0.0, input_vector.y).normalized()
	var camera_right := movement_camera.global_basis.x
	camera_right.y = 0.0
	camera_right = camera_right.normalized()
	var camera_forward := -movement_camera.global_basis.z
	camera_forward.y = 0.0
	camera_forward = camera_forward.normalized()
	return (camera_right * input_vector.x - camera_forward * input_vector.y).normalized()
