extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	for map_id in ["mjolnir_01", "mjolnir_02", "prontera"]:
		if not ResourceLoader.exists("res://assets/experimental/ro_reference/%s.glb" % map_id) or not ResourceLoader.exists("res://assets/experimental/ro_reference/%s_nav.gltf" % map_id):
			print("SKIP: mapas locais do cliente Ragnarok ausentes")
			quit()
			return
	var scene: Node3D = load("res://scenes/experimental/ragnarok_map_reference.tscn").instantiate()
	root.add_child(scene)
	current_scene = scene
	await physics_frame
	await physics_frame
	assert(scene.map_name == "mjolnir_01")
	assert(scene.actor != null)
	scene.actor.global_position = Vector3(37.0, 5.45, -11.29)
	scene.last_safe_position = scene.actor.global_position
	scene.actor.velocity = Vector3.ZERO
	scene.actor.movement_camera = null
	scene.actor.accept_player_input = false
	scene.actor.move_input = Vector2.RIGHT
	for i in range(90):
		await physics_frame
		if current_scene != null and current_scene.map_name == "mjolnir_02":
			break
	var second: Node3D = current_scene
	assert(second != null and second.map_name == "mjolnir_02")
	assert(second.actor != null)
	assert(second.actor.global_position.x < -30.0)
	assert(second.actor.is_clear_of_obstacles())
	second.actor.movement_camera = null
	second.actor.accept_player_input = false
	second.actor.move_input = Vector2.LEFT
	for i in range(150):
		await physics_frame
		if current_scene != null and current_scene.map_name == "mjolnir_01":
			break
	assert(current_scene.map_name == "mjolnir_01")
	var city: Node3D = load("res://scenes/experimental/prontera_reference.tscn").instantiate()
	root.add_child(city)
	await physics_frame
	await physics_frame
	assert(city.map_name == "prontera")
	assert(city.actor != null)
	assert(city.has_node("ColisaoGAT"))
	assert(is_equal_approx(city.map_scale, 4.0))
	assert(city.get_node("MapaVisualLocal").scale.is_equal_approx(Vector3.ONE * 4.0))
	assert(city.get_node("ColisaoGAT").scale.is_equal_approx(Vector3.ONE * 4.0))
	assert(is_equal_approx(city.actor.obstacle_cell_size, 8.0))
	assert(city.actor.is_clear_of_obstacles())
	assert(city.obstacle_count > 100)
	assert(not city.has_node("ColisaoPonte"))
	print("PASS: portal Mjolnir bidirecional e cena Prontera")
	quit()
