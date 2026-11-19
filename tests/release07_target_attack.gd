extends SceneTree

const ArenaScene = preload("res://scenes/arena.tscn")
const CrateScene = preload("res://scenes/crate.tscn")
const WallScene = preload("res://scenes/wall.tscn")
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(value: bool, label: String) -> void:
	if value:
		print("PASS: ", label)
	else:
		failures += 1
		push_error("FAIL: " + label)

func run_tests() -> void:
	var arena = ArenaScene.instantiate()
	root.add_child(arena)
	await physics_frame
	arena.player.position = Vector2(1527, 600)
	arena.player.facing = Vector2.RIGHT
	var close_crate = CrateScene.instantiate()
	close_crate.position = Vector2(1580, 600)
	arena.add_child(close_crate)
	await physics_frame
	check(arena.perform_attack() and close_crate.hp < close_crate.max_hp, "golpe acerta caixa encostada")
	close_crate.queue_free()
	await physics_frame
	arena.player.position = Vector2(1500, 600)
	var distant_crate = CrateScene.instantiate()
	distant_crate.position = Vector2(1750, 600)
	arena.add_child(distant_crate)
	await physics_frame
	var screen_point: Vector2 = arena.get_viewport().get_canvas_transform() * distant_crate.global_position
	var tap := InputEventScreenTouch.new()
	tap.index = 9
	tap.pressed = true
	tap.position = screen_point
	arena._input(tap)
	check(arena.selected_target == distant_crate and arena.target_attack_pending, "toque escolhe caixa fora do alcance")
	var start_position: Vector2 = arena.player.position
	for i in range(240):
		await physics_frame
		if distant_crate.hp < distant_crate.max_hp:
			break
	check(arena.player.position.distance_to(start_position) > 40.0, "Paladino aproxima automaticamente")
	check(distant_crate.hp < distant_crate.max_hp, "Paladino ataca ao chegar ao alcance")
	arena.player.position = Vector2(1300, 600)
	var bot = arena.combat.spawn_bot(Vector2(1600, 600))
	bot.attack_time = 1000.0
	await physics_frame
	var mouse := InputEventMouseButton.new()
	mouse.button_index = MOUSE_BUTTON_LEFT
	mouse.pressed = true
	mouse.position = arena.get_viewport().get_canvas_transform() * bot.global_position
	arena._input(mouse)
	check(arena.selected_target == bot and arena.target_attack_pending, "clique escolhe personagem")
	mouse.pressed = false
	arena._input(mouse)
	for i in range(240):
		await physics_frame
		if bot.hp < bot.max_hp:
			break
	check(bot.hp < bot.max_hp, "Paladino persegue e ataca personagem")
	arena.player.position = Vector2(1300, 600)
	arena.selected_target = bot
	arena.target_attack_pending = false
	var attack_touch := InputEventScreenTouch.new()
	attack_touch.index = 10
	attack_touch.pressed = true
	attack_touch.position = arena.ATTACK_CENTER
	arena._input(attack_touch)
	arena._physics_process(0.016)
	check(arena.target_attack_pending, "botão de ataque inicia aproximação ao alvo selecionado")
	attack_touch.pressed = false
	arena._input(attack_touch)
	bot.active = false
	bot.collision_layer = 0
	bot.position = Vector2(2200, 1200)
	await physics_frame
	arena.player.position = Vector2(1300, 600)
	var wall = WallScene.instantiate()
	wall.position = Vector2(1450, 600)
	wall.size = Vector2(32, 130)
	arena.add_child(wall)
	var around_crate = CrateScene.instantiate()
	around_crate.position = Vector2(1600, 600)
	arena.add_child(around_crate)
	await physics_frame
	arena.selected_target = around_crate
	arena.target_attack_pending = true
	arena.auto_waypoints.clear()
	for i in range(600):
		await physics_frame
		if around_crate.hp < around_crate.max_hp:
			break
	check(around_crate.hp < around_crate.max_hp, "aproximação contorna parede até a caixa")
	wall.queue_free()
	around_crate.queue_free()
	await physics_frame
	arena.player.position = Vector2(1300, 600)
	var corner_wall = WallScene.instantiate()
	corner_wall.position = Vector2(1360, 650)
	corner_wall.size = Vector2(90, 60)
	arena.add_child(corner_wall)
	var corner_crate = CrateScene.instantiate()
	corner_crate.position = Vector2(1540, 640)
	arena.add_child(corner_crate)
	await physics_frame
	arena.selected_target = corner_crate
	arena.target_attack_pending = true
	arena.auto_waypoints.clear()
	check(arena.target_visible_from(arena.player.global_position) and not arena.walk_path_clear_to_target(), "trajeto considera largura do personagem")
	for i in range(600):
		await physics_frame
		if corner_crate.hp < corner_crate.max_hp:
			break
	check(corner_crate.hp < corner_crate.max_hp, "Paladino evita quina e ataca a caixa")
	arena.queue_free()
	await process_frame
	if failures == 0:
		print("RELEASE 0.7 ALVO: todos os testes passaram")
	quit(0 if failures == 0 else 1)
