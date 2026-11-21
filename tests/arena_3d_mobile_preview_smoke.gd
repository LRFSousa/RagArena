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
	scene._on_action("FOR")
	assert(scene.determination_time > 0.0)
	scene.attack_cooldown = 0.0
	scene.actor.attack_time_remaining = 0.0
	scene._on_action("ATK")
	assert(scene.target_hp[0] == 50)
	scene._on_action("ALVO")
	assert(scene.selected_marker == 1)
	print("PASS: arena 3D, toque, ataque, dano e habilidades")
	quit()
