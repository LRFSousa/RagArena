extends SceneTree

const MountainScene = preload("res://scenes/experimental/mountain_arena_3d.tscn")
const Probe = preload("res://scripts/experimental/height_attack_probe.gd")
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		push_error("FAIL: " + label)

func step(frames: int) -> void:
	for i in range(frames):
		await physics_frame

func run_tests() -> void:
	var arena = MountainScene.instantiate()
	root.add_child(arena)
	var actor: MountainTestActor3D = arena.actor
	actor.accept_player_input = false
	await step(60)
	check(arena.platforms.size() == 3 and arena.ramps.size() == 2 and arena.rocks.size() == 3, "três patamares, duas rampas e rochas")
	check(actor is CharacterBody3D and actor.sprite is Sprite3D and actor.sprite.texture != null and arena.camera.current, "sprite 2D e câmera inclinada em cena 3D")
	check(absf(actor.global_position.y) < 0.15 and actor.is_on_floor(), "personagem aterrissa no patamar inferior")
	var space: PhysicsDirectSpaceState3D = arena.get_world_3d().direct_space_state
	var same: Dictionary = Probe.inspect(space, Vector3(-4, 0, 16), Vector3(-4, 0, 13))
	check(same["can_hit"] and same["reason"] == "clear", "golpe no mesmo patamar sem cobertura")
	var high: Dictionary = Probe.inspect(space, Vector3(-4, 0, 16), Vector3(-4, 2.5, 16))
	check(not high["can_hit"] and high["reason"] == "height", "altura excessiva impede golpe")
	var on_ramp: Dictionary = Probe.inspect(space, Vector3(-4, 0.36, 9), Vector3(-4, 1.43, 6))
	check(on_ramp["can_hit"], "golpe alcança alvo em altura diferente na mesma rampa")
	var skill_on_ramp: Dictionary = Probe.inspect(space, Vector3(-4, 0.18, 9.5), Vector3(-4, 1.57, 5.6), 4.5, 1.5)
	check(skill_on_ramp["can_hit"], "sonda de habilidade alcança altura moderada na rampa")
	var far: Dictionary = Probe.inspect(space, Vector3(-4, 0, 16), Vector3(-4, 0, 11))
	check(not far["can_hit"] and far["reason"] == "horizontal_range", "alcance horizontal é independente da altura")
	var covered: Dictionary = Probe.inspect(space, Vector3(-5, 2.5, 0), Vector3(-5, 2.5, -4), 5.0)
	check(not covered["can_hit"] and covered["reason"] == "cover", "rocha bloqueia linha de visão 3D")
	var skill_key := InputEventKey.new()
	skill_key.pressed = true
	skill_key.physical_keycode = KEY_F
	arena._unhandled_input(skill_key)
	check(arena.flash_time > 0.0 and arena.feedback.contains("clear"), "sonda de habilidade mostra efeito no alvo alcançável")
	actor.global_position = Vector3(-4, 0.8, 11)
	actor.move_input = Vector2(0, -1)
	await step(165)
	check(actor.global_position.y > 2.3 and actor.global_position.z < 3.0 and actor.is_on_floor(), "rampa inferior leva ao segundo patamar")
	actor.move_input = Vector2(0, 1)
	await step(165)
	check(actor.global_position.y < 0.2 and actor.is_on_floor(), "descida retorna ao patamar inferior sem salto")
	actor.global_position = Vector3(4, 3.2, -6)
	actor.move_input = Vector2(0, -1)
	await step(165)
	check(actor.global_position.y > 4.8 and actor.global_position.z < -14.0 and actor.is_on_floor(), "rampa superior leva ao terceiro patamar")
	actor.global_position = Vector3(0, 3.2, 1)
	actor.move_input = Vector2(0, -1)
	await step(100)
	check(actor.global_position.z < -3.0 and absf(actor.global_position.x) < 1.0, "passagem estreita é transitável")
	actor.global_position = Vector3(5, 0.8, 18)
	actor.move_input = Vector2(0, -1)
	await step(85)
	check(actor.global_position.z > 15.0, "rocha tem colisão física")
	actor.global_position = Vector3(10, 0.8, 16)
	actor.move_input = Vector2(1, 0)
	await step(80)
	check(actor.global_position.x < 12.0, "borda impede sair do patamar")
	actor.move_input = Vector2.ZERO
	arena.queue_free()
	await process_frame
	print("ARENA 3D: %d falhas" % failures)
	quit(0 if failures == 0 else 1)
