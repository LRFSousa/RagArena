extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var scene: Node3D = load("res://scenes/experimental/arena_3d_mobile_preview.tscn").instantiate()
	root.add_child(scene)
	for i in range(15):
		await physics_frame
	assert(scene.actor != null and scene.controls != null)
	assert(scene.markers.size() == 3)
	assert(scene.actor.model_3d != null)
	assert(scene.actor.attack_model_3d != null)
	assert(scene.camera is ArenaOrbitCamera3D)
	assert(scene.controls._map_rect().position.x > scene.controls.size.x * 0.5)
	assert(scene.controls._button_center("ATK").y > scene.controls._button_center("POT_HP").y)
	var original_distance: float = scene.camera.distance
	scene.camera.zoom_by_steps(-1)
	assert(scene.camera.distance < original_distance)
	var original_yaw: float = scene.camera.yaw_degrees
	scene.camera.orbit_by_pixels(Vector2(100, 0))
	assert(scene.camera.yaw_degrees != original_yaw)
	assert(scene.actor.movement_direction(Vector2(0, -1)).length() > 0.9)
	var touch := InputEventScreenTouch.new()
	touch.index = 0
	touch.position = scene.controls._joystick_center() + Vector2(50, 0)
	touch.pressed = true
	scene.controls._input(touch)
	assert(scene.controls.movement.x > 0.5)
	touch.pressed = false
	scene.controls._input(touch)
	assert(scene.controls.movement == Vector2.ZERO)
	scene.actor.global_position = Vector3(-4, 0.25, 13.7)
	scene.actor.velocity = Vector3.ZERO
	for i in range(5):
		await physics_frame
	scene._on_action("ATK")
	assert(scene.hits_landed == 1)
	assert(scene.target_hp[0] == 80)
	assert(scene.actor.attack_time_remaining > 0.0)
	scene._on_action("CURA")
	assert(scene.player_hp == 100)
	assert(scene.skill_cooldowns[1] > 0)
	scene._on_action("FOR")
	assert(scene.determination_time > 0.0)
	scene.attack_cooldown = 0.0
	scene.actor.attack_time_remaining = 0.0
	scene._on_action("ATK")
	assert(scene.target_hp[0] == 50)
	scene._on_action("ALVO")
	assert(scene.selected_marker == 1)
	scene.player_hp = 40
	scene._on_action("POT_HP")
	assert(scene.player_hp == 80 and scene.potions[0] == 2)
	print("PASS: arena 3D, toque, ataque, dano e habilidades")
	quit()
