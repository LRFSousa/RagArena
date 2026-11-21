extends Node3D

const MAP_FILE := "res://assets/experimental/ro_reference/mjolnir_01.glb"
const WALK_FILE := "res://assets/experimental/ro_reference/mjolnir_01_nav.gltf"
const ACTOR_SCENE := preload("res://scenes/experimental/test_actor_3d.tscn")
const CAMERA_SCRIPT := preload("res://scripts/experimental/orbit_camera_3d.gd")

var actor: MountainTestActor3D
var camera: ArenaOrbitCamera3D
var status: Label
var spawn_position := Vector3.ZERO
var last_safe_position := Vector3.ZERO
var bridge_collision_count := 0
var obstacle_grid: Dictionary = {}
var obstacle_count := 0
var passable_foliage_count := 0

func _ready() -> void:
	_build_ui()
	if not ResourceLoader.exists(MAP_FILE) or not ResourceLoader.exists(WALK_FILE):
		status.text = "Mapa local ausente. Veja docs/ARENA_3D_MAPA_REFERENCIA.md."
		return
	var visual := (load(MAP_FILE) as PackedScene).instantiate()
	visual.name = "MapaVisualLocal"
	add_child(visual)
	bridge_collision_count = _add_bridge_collision()
	obstacle_count = _collect_obstacles(visual)
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
	last_safe_position = spawn_position
	walk_scene.queue_free()
	actor = ACTOR_SCENE.instantiate()
	actor.position = spawn_position
	actor.use_3d_model = true
	actor.guard_walkable_edges = true
	actor.lock_elevation_level = true
	actor.locked_floor_height = roundf(spawn.y / 2.8) * 2.8
	actor.obstacle_grid = obstacle_grid
	actor.collision_mask = 1 | 4
	add_child(actor)
	camera = CAMERA_SCRIPT.new()
	camera.target = actor
	camera.current = true
	add_child(camera)
	actor.movement_camera = camera
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
	_update_status()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_R and actor != null:
		_recover_actor()
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_T and actor != null and actor.model_3d != null:
		actor.model_3d.visible = not actor.model_3d.visible
		actor.sprite.visible = not actor.model_3d.visible
		_update_status()

func _update_status() -> void:
	var mode := "3D" if actor != null and actor.model_3d != null and actor.model_3d.visible else "sprite 2D"
	status.text = "Monte Mjolnir 01 | Espadachim %s | WASD: mover | R: recuperar | T: alternar | Espaço: golpe | Botão direito: girar | Roda: zoom" % mode

func _physics_process(_delta: float) -> void:
	if actor == null:
		return
	if actor.is_on_floor() and actor.is_clear_of_obstacles():
		last_safe_position = actor.global_position
	elif actor.global_position.y < last_safe_position.y - 2.5:
		_recover_actor()

func _recover_actor() -> void:
	actor.global_position = last_safe_position
	actor.velocity = Vector3.ZERO

func _collect_obstacles(node: Node) -> int:
	var count := 0
	for child in node.get_children():
		if not (child is Node3D) or not str(child.name).contains("_rsm") or str(child.name).contains("다리"):
			continue
		var model_name := str(child.name)
		model_name = model_name.substr(model_name.rfind("\\") + 1)
		if _is_passable_foliage(model_name):
			passable_foliage_count += 1
			continue
		var radius := 0.45
		if model_name.contains("꽃"):
			radius = 0.72
		elif model_name.contains("나무") or model_name.contains("소나무"):
			radius = 0.65
		elif model_name.contains("풍차") or model_name.contains("폐가"):
			radius = 1.2
		var position_3d: Vector3 = (child as Node3D).global_position
		var cell := Vector2i(floori(position_3d.x / 2.0), floori(position_3d.z / 2.0))
		if not obstacle_grid.has(cell):
			obstacle_grid[cell] = []
		obstacle_grid[cell].append(Vector4(position_3d.x, position_3d.y, position_3d.z, radius))
		count += 1
	return count

func _is_passable_foliage(model_name: String) -> bool:
	# Folhagens rasteiras são decorativas; flores altas e objetos sólidos continuam bloqueados.
	return model_name.contains("덤불") or model_name.contains("잡초") or model_name.contains("풀") or model_name.contains("넝쿨")

func _add_bridge_collision() -> int:
	var body := StaticBody3D.new()
	body.name = "ColisaoPonte"
	body.collision_layer = 4
	add_child(body)
	# O GAT possui pequenas lacunas nas extremidades da ponte visual.
	# Piso contínuo de teste, alinhado aos pontos medidos na ponte de mjolnir_01.
	var deck := [
		Vector2(11, 5.465), Vector2(13, 5.173), Vector2(15, 4.909),
		Vector2(17, 4.671), Vector2(19, 4.479), Vector2(21, 4.329),
		Vector2(23, 4.242), Vector2(25, 4.220), Vector2(27, 4.260),
		Vector2(29, 4.369), Vector2(31, 4.520), Vector2(33, 4.720),
		Vector2(35, 4.967), Vector2(37, 5.250), Vector2(39, 5.600),
	]
	for i in range(deck.size() - 1):
		var start: Vector2 = deck[i]
		var finish: Vector2 = deck[i + 1]
		var collider := CollisionShape3D.new()
		var box := BoxShape3D.new()
		box.size = Vector3(start.distance_to(finish) + 0.04, 0.18, 1.8)
		collider.shape = box
		collider.position = Vector3((start.x + finish.x) * 0.5, (start.y + finish.y) * 0.5 - 0.09, -11.29)
		collider.rotation.z = atan2(finish.y - start.y, finish.x - start.x)
		body.add_child(collider)
	return deck.size() - 1

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
			if current < score and _is_clear_spawn(vertex):
				score = current
				best = vertex
	return best

func _is_clear_spawn(point: Vector3) -> bool:
	for offset in [Vector2.ZERO, Vector2(0.5, 0), Vector2(-0.5, 0), Vector2(0, 0.5), Vector2(0, -0.5)]:
		var sample := point + Vector3(offset.x, 0, offset.y)
		var query := PhysicsRayQueryParameters3D.create(sample + Vector3.UP, sample + Vector3.DOWN, 1)
		var hit := get_world_3d().direct_space_state.intersect_ray(query)
		if hit.is_empty() or absf(hit.position.y - point.y) > 0.4:
			return false
	var cell := Vector2i(floori(point.x / 2.0), floori(point.z / 2.0))
	for dx in range(-1, 2):
		for dz in range(-1, 2):
			for entry in obstacle_grid.get(cell + Vector2i(dx, dz), []):
				var obstacle: Vector4 = entry
				if absf(obstacle.y - point.y) <= 1.4 and Vector2(point.x, point.z).distance_to(Vector2(obstacle.x, obstacle.z)) < obstacle.w + 0.25:
					return false
	return true

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
