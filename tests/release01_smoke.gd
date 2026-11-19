extends SceneTree

const CombatRules = preload("res://scripts/combat_rules.gd")
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(condition: bool, message: String) -> void:
	if condition:
		print("PASS: ", message)
	else:
		failures += 1
		push_error("FAIL: " + message)

func run_tests() -> void:
	check(CombatRules.crate_damage(1) == 15, "nível 1 causa 15")
	check(CombatRules.crate_damage(3) == 15, "nível 3 causa 15")
	check(CombatRules.crate_damage(4) == 23, "nível 4 causa 23")
	check(CombatRules.crate_damage(7) == 23, "nível 7 causa 23")
	check(CombatRules.crate_damage(8) == 45, "nível 8 causa 45")
	check(CombatRules.crate_damage(30) == 45, "nível 30 causa 45")
	for spec in [[1, 3], [4, 2], [8, 1]]:
		await test_crate(spec[0], spec[1])
	await test_direction_and_cadence()
	await test_wall_blocks_attack()
	await test_touch_controls()
	await test_collision()
	await test_restart()
	if failures == 0:
		print("RELEASE 0.1: todos os testes passaram")
	quit(0 if failures == 0 else 1)

func load_arena() -> Node:
	change_scene_to_file("res://scenes/arena.tscn")
	await process_frame
	await process_frame
	return current_scene

func test_crate(level: int, hits_needed: int) -> void:
	var arena := await load_arena()
	arena.test_level = level
	arena.update_hud()
	var crate: StaticBody2D = null
	for child in arena.get_children():
		if child is StaticBody2D and child.destructible and child.position == Vector2(194, 290):
			crate = child
			break
	check(crate != null, "caixa de teste presente")
	if crate == null:
		return
	check(crate.hp == 45, "caixa inicia com 45 HP")
	check(arena.wooden_blocks == 24, "24 caixas no mapa ampliado")
	arena.player.position = Vector2(194, 210)
	arena.player.facing = Vector2.DOWN
	for i in range(hits_needed):
		arena.perform_attack()
		await process_frame
		if i < hits_needed - 1:
			check(is_instance_valid(crate) and crate.hp > 0, "nível %d: caixa resiste ao golpe %d" % [level, i + 1])
	check(arena.destroyed_blocks == 1, "nível %d: destrói em %d golpes" % [level, hits_needed])
	check(arena.wooden_blocks == 23, "contador de restantes atualizado")
	check("Caixas destruídas: 1" in arena.hud.text, "HUD mostra caixa destruída")
	arena.attack_held = false
	arena.attack_touch = -1

func test_direction_and_cadence() -> void:
	var arena := await load_arena()
	var crate: StaticBody2D = null
	for child in arena.get_children():
		if child is StaticBody2D and child.destructible and child.position == Vector2(194, 290):
			crate = child
			break
	arena.player.position = Vector2(194, 210)
	arena.player.facing = Vector2.UP
	arena.attack_touch = 1
	arena.attack_held = true
	await physics_frame
	await process_frame
	check(crate.hp == 45, "ataque na direção oposta não causa dano")
	arena.player.facing = Vector2.DOWN
	arena.attack_timer = 0.0
	await physics_frame
	await process_frame
	check(crate.hp == 30, "ataque direcionado atinge caixa")
	for i in range(10):
		await physics_frame
		await process_frame
	check(crate.hp == 30, "segurar ataque respeita cadência de 0,42 s")
	arena.attack_held = false
	arena.attack_touch = -1

func test_wall_blocks_attack() -> void:
	var arena := await load_arena()
	var wall = load("res://scenes/wall.tscn").instantiate()
	wall.position = Vector2(650, 350)
	wall.size = Vector2(20, 60)
	arena.add_child(wall)
	var crate = load("res://scenes/crate.tscn").instantiate()
	crate.position = Vector2(690, 350)
	arena.add_child(crate)
	arena.player.position = Vector2(600, 350)
	arena.player.facing = Vector2.RIGHT
	arena.attack_touch = 1
	arena.attack_held = true
	await physics_frame
	await process_frame
	check(crate.hp == 45, "parede impede ataque de alcançar caixa")
	arena.attack_held = false
	arena.attack_touch = -1

func test_touch_controls() -> void:
	var arena := await load_arena()
	var touch := InputEventScreenTouch.new()
	touch.index = 0
	touch.position = Vector2(130, 570)
	touch.pressed = true
	arena._input(touch)
	var drag := InputEventScreenDrag.new()
	drag.index = 0
	drag.position = Vector2(202, 570)
	arena._input(drag)
	check(arena.joystick_value.x > 0.9, "joystick virtual produz direção horizontal")
	touch.pressed = false
	arena._input(touch)
	check(arena.joystick_value == Vector2.ZERO, "joystick solto para movimento")
	var attack := InputEventScreenTouch.new()
	attack.index = 1
	attack.position = arena.ATTACK_CENTER
	attack.pressed = true
	arena._input(attack)
	check(arena.attack_held, "toque segura ataque")
	attack.pressed = false
	arena._input(attack)
	check(not arena.attack_held, "soltar toque encerra ataque")

func test_collision() -> void:
	var arena := await load_arena()
	arena.player.position = Vector2(90, 360)
	Input.action_press("move_left")
	for i in range(40):
		await physics_frame
		await process_frame
	Input.action_release("move_left")
	check(arena.player.position.x >= 70, "jogador não atravessa a parede externa")
	check(arena.player.position.x < 90, "jogador se move até a parede")

func test_restart() -> void:
	var arena := await load_arena()
	arena.destroyed_blocks = 2
	Input.action_press("restart")
	await physics_frame
	Input.action_release("restart")
	await process_frame
	await process_frame
	var restarted := current_scene
	check(restarted.destroyed_blocks == 0 and restarted.wooden_blocks == 24, "reinício limpa contadores")
