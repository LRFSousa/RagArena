extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene: Arena01Playtest = load("res://scenes/Arena01.tscn").instantiate()
	root.add_child(scene)
	for i in range(15):
		await physics_frame
	assert(scene.actor != null and scene.camera != null and scene.controls != null)
	assert(scene.actor.model_3d != null)
	assert(scene.markers.size() == 3)
	assert(scene.map_bounds.size == Vector2(80, 80))
	for name in ["Piso", "MorroOeste", "MorroOeste2", "RampaOeste", "RampaLeste", "RuinaCentralBase", "Rocha01"]:
		assert((scene.get_node(name) as CSGShape3D).use_collision, "%s precisa de colisão" % name)
	var space := scene.get_world_3d().direct_space_state
	var hill_hit := space.intersect_ray(PhysicsRayQueryParameters3D.create(Vector3(-20, 10, -20), Vector3(-20, -2, -20), 1))
	assert(not hill_hit.is_empty() and absf(hill_hit.position.y - 5) < 0.2)
	var rock_hit := space.intersect_ray(PhysicsRayQueryParameters3D.create(Vector3(21, 4, 0), Vector3(21, -2, 0), 1))
	assert(not rock_hit.is_empty() and rock_hit.position.y > 0.5)
	for z in [-39.5, 39.5]:
		var boundary_hit := space.intersect_ray(PhysicsRayQueryParameters3D.create(Vector3(0, 1, z - 2), Vector3(0, 1, z + 2), 1))
		assert(not boundary_hit.is_empty(), "A borda central da arena deve estar fechada")
	var start := scene.actor.global_position
	scene.controls.movement = Vector2(0, -1)
	for i in range(25):
		await physics_frame
	assert(Vector2(scene.actor.global_position.x, scene.actor.global_position.z).distance_to(Vector2(start.x, start.z)) > 0.1)
	scene.controls.movement = Vector2.ZERO
	scene.actor.global_position = Vector3(0, 0.1, -8.5)
	scene.actor.velocity = Vector3.ZERO
	for i in range(5):
		await physics_frame
	scene._on_action("ATK")
	assert(scene.hits_landed == 1 and scene.target_hp[0] == 80)
	scene._on_action("FOR")
	assert(scene.determination_time > 0)
	scene.attack_cooldown = 0
	scene.actor.attack_time_remaining = 0
	scene._on_action("ATK")
	assert(scene.target_hp[0] == 50)
	scene._on_action("ALVO")
	assert(scene.selected_marker == 1)
	scene.player_hp = 50
	scene._on_action("POT_HP")
	assert(scene.player_hp == 90 and scene.potions[0] == 2)
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	click.position = scene.controls._button_center("ESC")
	scene.controls._input(click)
	assert(scene.shield_time > 0 and scene.skill_cooldowns[0] > 0)
	click.position = scene.controls._button_center("ALVO")
	scene.controls._input(click)
	assert(scene.selected_marker == 2)
	click.position = scene.controls._button_center("POT_ELIXIR")
	scene.controls._input(click)
	assert(scene.potions[1] == 1)
	var old_zoom: float = scene.camera.distance
	click.position = scene.controls._button_center("ZOOM_IN")
	scene.controls._input(click)
	assert(scene.camera.distance < old_zoom)
	scene.selected_marker = 0
	scene.attack_cooldown = 0
	scene.actor.attack_time_remaining = 0
	click.position = scene.controls._button_center("ATK")
	scene.controls._input(click)
	assert(scene.hits_landed == 3 and scene.target_hp[0] == 20)
	scene.actor.global_position = Vector3(1, 0.2, -29)
	scene.actor.velocity = Vector3.ZERO
	scene.actor.guard_walkable_edges = true
	for i in range(10):
		await physics_frame
	scene.controls.movement = Vector2(-1, 0)
	for i in range(200):
		await physics_frame
	scene.controls.movement = Vector2.ZERO
	assert(scene.actor.global_position.y > 4.0, "RampaLeste deve permitir subir o morro")
	scene.actor.global_position = Vector3(0, 0.2, 32.66)
	scene.actor.velocity = Vector3.ZERO
	for i in range(10):
		await physics_frame
	scene.controls.movement = Vector2(1, 0)
	for i in range(200):
		await physics_frame
	scene.controls.movement = Vector2.ZERO
	assert(scene.actor.global_position.y > 4.0, "RampaLeste2 deve permitir subir o segundo morro")
	print("PASS: Arena01, colisões, movimentação, ataque, habilidades e itens")
	quit()
