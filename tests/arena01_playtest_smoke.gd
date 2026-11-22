extends SceneTree

const Probe = preload("res://scripts/experimental/height_attack_probe.gd")
const Store = preload("res://scripts/local_profile_store.gd")
const PROFILE_PATH := "res://tests/.arena01_attributes_ui_test.json"

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	for suffix in ["", ".bak"]:
		if FileAccess.file_exists(PROFILE_PATH + suffix):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(PROFILE_PATH + suffix))
	var backup: Node3D = load("res://scenes/Arena01_80x80_backup.tscn").instantiate()
	assert((backup.get_node("Piso") as CSGBox3D).size == Vector3(80, 1, 80))
	var scene: Arena01Playtest = load("res://scenes/Arena01.tscn").instantiate()
	root.add_child(scene)
	for i in range(15):
		await physics_frame
	assert(scene.map_bounds == Rect2(-80, -80, 160, 160))
	assert((scene.get_node("Piso") as CSGBox3D).size == Vector3(160, 1, 160))
	assert(scene.controls._map_point(Vector2(-80, -80), Rect2(0, 0, 100, 100)) == Vector2.ZERO)
	assert(scene.controls._map_point(Vector2(80, 80), Rect2(0, 0, 100, 100)) == Vector2(100, 100))
	assert(scene.actor.model_3d != null and scene.camera != null and scene.controls != null)
	scene.profile_store = Store.new(PROFILE_PATH)
	assert(scene.profile_store.create_identity("Conta_Arena") and scene.profile_store.create_character("Espada_Arena", "swordsman") != "")
	scene._grant_test_exp()
	var test_id: String = str(scene.profile_store.data["selected_character_id"])
	assert(int(scene.profile_store.find_character(test_id)["attribute_points"]) > 0, "EXP de teste deve conceder pontos na Arena01")
	scene.show_attributes()
	assert(is_instance_valid(scene.attribute_window) and scene.attribute_window.content.get_child_count() >= 10 and scene.attribute_window.overview.get_child_count() >= 9)
	var hits_before_modal: int = scene.hits_landed
	var modal_click := InputEventMouseButton.new()
	modal_click.button_index = MOUSE_BUTTON_LEFT
	modal_click.pressed = true
	modal_click.position = scene.controls._button_center("ATK")
	scene.controls._input(modal_click)
	assert(scene.hits_landed == hits_before_modal, "Janela aberta bloqueia ataque por baixo")
	scene.attribute_window.closed.emit()
	await process_frame
	assert(not is_instance_valid(scene.attribute_window), "Janela fecha sem bloquear a arena")
	scene.show_skills()
	assert(is_instance_valid(scene.skill_window) and scene.skill_window.list.get_child_count() > 10, "Árvore de habilidades abre na Arena01")
	scene.controls._input(modal_click)
	assert(scene.hits_landed == hits_before_modal, "Janela de habilidades bloqueia ataque por baixo")
	scene.skill_window.closed.emit()
	await process_frame
	assert(not is_instance_valid(scene.skill_window), "Janela de habilidades fecha")
	assert(is_equal_approx(scene.actor.speed, 8.0), "Arena ampliada deve usar deslocamento dobrado")
	assert(scene.markers.size() == 3)
	assert(Vector2(scene.get_node("MorroOeste").position.x, scene.get_node("MorroOeste").position.z).distance_to(Vector2(scene.get_node("MorroOeste2").position.x, scene.get_node("MorroOeste2").position.z)) > 100)
	for name in ["MorroOeste", "MorroOeste2"]:
		assert((scene.get_node(name) as CSGBox3D).size == (backup.get_node(name) as CSGBox3D).size)
	for name in ["RampaOeste", "RampaLeste", "RampaOeste2", "RampaLeste2"]:
		var ramp: CSGPolygon3D = scene.get_node(name)
		var old_ramp: CSGPolygon3D = backup.get_node(name)
		assert(ramp.polygon == old_ramp.polygon and ramp.depth == old_ramp.depth)
		assert(ramp.use_collision)
	for name in ["RuinaCentralBase", "MuroInterno01", "Cerca01", "Rocha01"]:
		assert((scene.get_node(name) as CSGBox3D).size == (backup.get_node(name) as CSGBox3D).size)
	backup.free()
	var space := scene.get_world_3d().direct_space_state
	for name in ["RampaOeste", "RampaLeste", "RampaOeste2", "RampaLeste2"]:
		for side in ["A", "B"]:
			var rail: StaticBody3D = scene.get_node(name + "Borda" + side)
			assert(rail.collision_layer == 1 and rail.get_child_count() == 2, "Rampas precisam de bordas físicas")
	for point in [Vector2(-70, -70), Vector2(70, -70), Vector2(-70, 70), Vector2(70, 70)]:
		var ground := space.intersect_ray(PhysicsRayQueryParameters3D.create(Vector3(point.x, 3, point.y), Vector3(point.x, -2, point.y), 1))
		assert(not ground.is_empty() and absf(ground.position.y) < 0.2)
	for point in [Vector2(-48, -48), Vector2(48, 48)]:
		var hill := space.intersect_ray(PhysicsRayQueryParameters3D.create(Vector3(point.x, 10, point.y), Vector3(point.x, -2, point.y), 1))
		assert(not hill.is_empty() and absf(hill.position.y - 5) < 0.2)
	for z in [-79.5, 79.5]:
		var boundary := space.intersect_ray(PhysicsRayQueryParameters3D.create(Vector3(0, 1, z - 2), Vector3(0, 1, z + 2), 1))
		assert(not boundary.is_empty())
	var cover: Dictionary = Probe.inspect(space, Vector3(3.5, 0, -7), Vector3(3.5, 0, 7), 30)
	assert(not cover["can_hit"] and cover["reason"] == "cover")
	scene.actor.global_position = Vector3(0, 0.1, -18.5)
	scene.actor.velocity = Vector3.ZERO
	scene.actor.face_world_direction(Vector3(0, 0, -1))
	for i in range(5):
		await physics_frame
	var initial_yaw: float = scene.actor.model_3d.rotation.y
	scene._on_action("ATK")
	assert(scene.hits_landed == 1 and scene.target_hp[0] == 100 - int(ArenaDerivedStats.calculate(scene.profile_store.find_character(test_id))["atk"]))
	assert(is_equal_approx(scene.actor.model_3d.rotation.y, initial_yaw), "Golpe não deve virar de lado diante do alvo")
	scene.camera.orbit_by_pixels(Vector2(-188, 0))
	var camera_forward := -scene.camera.global_basis.z
	camera_forward.y = 0
	scene.actor.face_world_direction(scene.actor.movement_direction(Vector2(0, -1)))
	assert(scene.actor.facing_world.dot(camera_forward.normalized()) > 0.99)
	scene.actor.attack_time_remaining = 0
	scene.controls.movement = Vector2(0, -1)
	for i in range(25):
		await physics_frame
	scene.controls.movement = Vector2.ZERO
	assert(scene.actor.facing_world.dot(camera_forward.normalized()) > 0.99)
	scene.actor.global_position = Vector3(0, 0.1, -18.5)
	scene.actor.velocity = Vector3.ZERO
	scene.camera.yaw_degrees = 0
	scene.camera.orbit_by_pixels(Vector2.ZERO)
	scene._on_action("FOR")
	scene.attack_cooldown = 0
	scene.actor.attack_time_remaining = 0
	scene.actor.face_world_direction(Vector3(0, 0, -1))
	scene._on_action("ATK")
	assert(scene.target_hp[0] == 100 - 2 * int(ArenaDerivedStats.calculate(scene.profile_store.find_character(test_id))["atk"]) - 10)
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	click.pressed = true
	click.position = scene.controls._button_center("ESC")
	scene.controls._input(click)
	assert(scene.shield_time > 0)
	click.position = scene.controls._button_center("ALVO")
	scene.controls._input(click)
	assert(scene.selected_marker == 1)
	scene.attack_cooldown = 0
	scene.actor.attack_time_remaining = 0
	scene.actor.face_world_direction(Vector3(0, 0, -1))
	var yaw_before_miss: float = scene.actor.model_3d.rotation.y
	scene._on_action("ATK")
	assert(is_equal_approx(scene.actor.model_3d.rotation.y, yaw_before_miss), "Alvo distante não deve girar o corpo")
	scene.player_hp = 50
	click.position = scene.controls._button_center("POT_HP")
	scene.controls._input(click)
	assert(scene.player_hp == 90 and scene.potions[0] == 2)
	for entry in [
		[Vector3(-51, 0.2, -25), Vector2(0, -1)],
		[Vector3(-25, 0.2, -57), Vector2(-1, 0)],
		[Vector3(52, 0.2, 25), Vector2(0, 1)],
		[Vector3(25, 0.2, 57), Vector2(1, 0)],
	]:
		scene.actor.global_position = entry[0]
		scene.actor.velocity = Vector3.ZERO
		for i in range(10):
			await physics_frame
		scene.controls.movement = entry[1]
		for i in range(200):
			await physics_frame
		scene.controls.movement = Vector2.ZERO
		assert(scene.actor.global_position.y > 4, "Todas as rampas devem levar ao alto dos morros")
		scene.controls.movement = -entry[1]
		for i in range(220):
			await physics_frame
		scene.controls.movement = Vector2.ZERO
		assert(scene.actor.global_position.y < 1, "Todas as rampas devem permitir descer")
	scene.actor.global_position = Vector3(-52, 2.6, -31)
	scene.actor.velocity = Vector3.ZERO
	scene.actor.attack_time_remaining = 0
	for i in range(5):
		await physics_frame
	scene.controls.movement = Vector2(1, -1)
	for i in range(25):
		await physics_frame
	scene.controls.movement = Vector2.ZERO
	assert(scene.actor.global_position.x < -50.3 and scene.actor.global_position.y > 2.5, "Movimento diagonal não deve sair pela lateral da rampa")
	scene.actor.global_position = Vector3(70, 0.1, 70)
	scene.camera.zoom_by_steps(100)
	assert(is_equal_approx(scene.camera.distance, scene.camera.max_distance))
	for i in range(40):
		await process_frame
	for yaw in [0.0, 45.0, 90.0]:
		for pitch in [15.0, 42.0, 78.0]:
			scene.camera.yaw_degrees = yaw
			scene.camera.pitch_degrees = pitch
			scene.camera.orbit_by_pixels(Vector2.ZERO)
			for point in [Vector3(-80, 0, -80), Vector3(80, 0, -80), Vector3(-80, 0, 80), Vector3(80, 0, 80)]:
				assert(not scene.camera.is_position_behind(point))
				var screen := scene.camera.unproject_position(point)
				assert(screen.x >= 0 and screen.x <= 1280 and screen.y >= 0 and screen.y <= 720, "Zoom máximo deve mostrar toda a arena")
	scene.camera.zoom_by_steps(-100)
	assert(is_equal_approx(scene.camera.distance, scene.camera.min_distance))
	print("PASS: Arena01 160x160, backup, quatro rampas, ataque orientado, minimapa e zoom")
	for suffix in ["", ".bak"]:
		if FileAccess.file_exists(PROFILE_PATH + suffix):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(PROFILE_PATH + suffix))
	quit()
