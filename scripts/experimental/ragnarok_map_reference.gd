extends Node3D

const MAP_FILE := "res://assets/experimental/ro_reference/mjolnir_01.glb"
const WALK_FILE := "res://assets/experimental/ro_reference/mjolnir_01_nav.gltf"
const ACTOR_SCENE := preload("res://scenes/experimental/test_actor_3d.tscn")
const CAMERA_SCRIPT := preload("res://scripts/experimental/test_camera_3d.gd")

var actor: MountainTestActor3D
var camera: MountainTestCamera3D
var status: Label
var spawn_position := Vector3.ZERO

func _ready() -> void:
	_build_ui()
	if not ResourceLoader.exists(MAP_FILE) or not ResourceLoader.exists(WALK_FILE):
		status.text = "Mapa local ausente. Veja docs/ARENA_3D_MAPA_REFERENCIA.md."
		return
	var visual := (load(MAP_FILE) as PackedScene).instantiate()
	visual.name = "MapaVisualLocal"
	add_child(visual)
	var walk_scene := (load(WALK_FILE) as PackedScene).instantiate()
	var walk_mesh := _find_mesh(walk_scene)
	if walk_mesh == null:
		status.text = "Malha caminhável não encontrada."
		walk_scene.queue_free()
		return
	var body := StaticBody3D.new()
	body.name = "ColisaoGAT"
	body.collision_layer = 1
	var shape := CollisionShape3D.new()
	shape.shape = walk_mesh.mesh.create_trimesh_shape()
	body.add_child(shape)
	add_child(body)
	var spawn := _find_spawn(walk_mesh.mesh)
	spawn_position = spawn + Vector3.UP * 0.2
	walk_scene.queue_free()
	actor = ACTOR_SCENE.instantiate()
	actor.position = spawn_position
	add_child(actor)
	camera = CAMERA_SCRIPT.new()
	camera.camera_offset = Vector3(0.0, 15.0, 29.0)
	camera.target = actor
	camera.current = true
	add_child(camera)
	camera.size = 30.0
	camera.far = 300.0
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-55, -30, 0)
	sun.light_energy = 0.65
	add_child(sun)
	var environment := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.43, 0.56, 0.73)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.42, 0.42, 0.42)
	environment.environment = env
	add_child(environment)
	status.text = "Monte Mjolnir 01 | WASD: mover | Segurar C: visão ampla | Colisão: células GAT"

func _process(_delta: float) -> void:
	if actor != null and actor.global_position.y < -10.0:
		actor.global_position = spawn_position
		actor.velocity = Vector3.ZERO
	if camera != null and Input.is_key_pressed(KEY_C):
		camera.size = 72.0
	elif camera != null:
		camera.size = 30.0

func _find_mesh(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var found := _find_mesh(child)
		if found != null:
			return found
	return null

func _find_spawn(mesh: Mesh) -> Vector3:
	var best := Vector3.ZERO
	var score := INF
	for surface in mesh.get_surface_count():
		var vertices: PackedVector3Array = mesh.surface_get_arrays(surface)[Mesh.ARRAY_VERTEX]
		for vertex in vertices:
			var current := Vector2(vertex.x, vertex.z).length_squared() + absf(vertex.y) * 0.05
			if current < score:
				score = current
				best = vertex
	return best

func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	status = Label.new()
	status.position = Vector2(20, 18)
	status.add_theme_color_override("font_color", Color.WHITE)
	status.add_theme_color_override("font_shadow_color", Color.BLACK)
	status.add_theme_constant_override("shadow_offset_x", 2)
	status.add_theme_constant_override("shadow_offset_y", 2)
	layer.add_child(status)
