extends SceneTree

const MAP_FILE := "res://assets/experimental/ro_reference/mjolnir_01.glb"
const WALK_FILE := "res://assets/experimental/ro_reference/mjolnir_01_nav.gltf"

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	if not ResourceLoader.exists(MAP_FILE) or not ResourceLoader.exists(WALK_FILE):
		print("SKIP: arquivos locais do cliente Ragnarok ausentes")
		quit()
		return
	var scene: Node3D = load("res://scenes/experimental/ragnarok_map_reference.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	assert(scene.has_node("MapaVisualLocal"))
	assert(scene.has_node("ColisaoGAT"))
	assert(scene.actor != null)
	assert(scene.camera != null)
	assert(scene.camera.projection == Camera3D.PROJECTION_PERSPECTIVE)
	var start_yaw: float = scene.camera.yaw_degrees
	scene.camera.orbit_by_pixels(Vector2(-1000.0, 0.0))
	assert(scene.camera.yaw_degrees != start_yaw)
	assert(scene.camera.yaw_degrees >= 0.0 and scene.camera.yaw_degrees < 360.0)
	scene.camera.orbit_by_pixels(Vector2(-500.0, 0.0))
	assert(is_equal_approx(scene.camera.yaw_degrees, start_yaw))
	scene.camera.orbit_by_pixels(Vector2(0.0, 1000.0))
	assert(is_equal_approx(scene.camera.pitch_degrees, 78.0))
	scene.camera.zoom_by_steps(-100.0)
	assert(is_equal_approx(scene.camera.distance, scene.camera.min_distance))
	scene.camera.zoom_by_steps(100.0)
	assert(is_equal_approx(scene.camera.distance, scene.camera.max_distance))
	var mouse_down := InputEventMouseButton.new()
	mouse_down.button_index = MOUSE_BUTTON_RIGHT
	mouse_down.pressed = true
	scene.camera._unhandled_input(mouse_down)
	var mouse_drag := InputEventMouseMotion.new()
	mouse_drag.relative = Vector2(100, 0)
	scene.camera._unhandled_input(mouse_drag)
	assert(not is_equal_approx(scene.camera.yaw_degrees, start_yaw))
	var touch_one := InputEventScreenTouch.new()
	touch_one.index = 0
	touch_one.position = Vector2(100, 100)
	touch_one.pressed = true
	scene.camera._unhandled_input(touch_one)
	var touch_two := InputEventScreenTouch.new()
	touch_two.index = 1
	touch_two.position = Vector2(200, 100)
	touch_two.pressed = true
	scene.camera._unhandled_input(touch_two)
	var pinch := InputEventScreenDrag.new()
	pinch.index = 1
	pinch.position = Vector2(250, 100)
	pinch.relative = Vector2(50, 0)
	scene.camera._unhandled_input(pinch)
	assert(scene.camera.distance < scene.camera.max_distance)
	var body: StaticBody3D = scene.get_node("ColisaoGAT")
	assert(body.get_child(0).shape is ConcavePolygonShape3D)
	for i in range(30):
		await physics_frame
	assert(scene.actor.is_on_floor())
	print("PASS: mapa completo, malha GAT, ator no chão, órbita e zoom")
	quit()
