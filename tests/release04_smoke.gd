extends SceneTree

const ArenaScene = preload("res://scenes/arena.tscn")
const Rules = preload("res://scripts/match_settings.gd")
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		push_error("FAIL: " + label)

func make_arena(participants: int) -> Node2D:
	var arena = ArenaScene.instantiate()
	root.add_child(arena)
	current_scene = arena
	var rules = Rules.new()
	rules.participants = participants
	arena.match_controller.configure(arena, arena.combat, arena.inventory, arena.progression, rules)
	return arena

func remove_arena(arena: Node2D) -> void:
	arena.queue_free()
	current_scene = null

func run_tests() -> void:
	for count in range(2, 6):
		var arena = make_arena(count)
		await physics_frame
		var match_controller: MatchController = arena.match_controller
		check(match_controller.state == "active" and match_controller.alive_count() == count and arena.combat.bots.size() == count - 1, "%d participantes começam ativos" % count)
		check(arena.progression.level == 1 and arena.progression.xp == 0 and arena.inventory.slots[0]["id"] == "" and arena.inventory.hp == arena.combat.max_hp(), "%d participantes começam com estado limpo" % count)
		match_controller.advance(330.0)
		check(match_controller.state == "active" and match_controller.current_safe_rect.size.x < MatchController.FULL_ARENA.size.x, "fechamento funciona com %d participantes" % count)
		for bot in arena.combat.bots:
			bot.take_hit(999)
		match_controller.advance(0.0)
		check(match_controller.state == "results" and match_controller.result["winner"] == "Jogador" and match_controller.result["reason"] == "last_survivor" and match_controller.elapsed < 480.0, "%d participantes encerram com sobrevivente único" % count)
		check(match_controller.result["participants"] == count and match_controller.result["level"] == 1, "resultado registra estatísticas com %d participantes" % count)
		remove_arena(arena)
		await process_frame
	var arena = make_arena(3)
	await physics_frame
	var match_controller: MatchController = arena.match_controller
	match_controller.settings.shrink_start = 10.0
	match_controller.settings.shrink_duration = 10.0
	match_controller.settings.warning_lead = 3.0
	match_controller.settings.max_inset = 100.0
	match_controller.settings.time_limit = 30.0
	match_controller.advance(7.0)
	check(match_controller.status_text().contains("Atenção"), "aviso antecede fechamento")
	var item = arena.spawn_ground_item("health_potion", Vector2(70, 70))
	match_controller.advance(8.0)
	check(match_controller.current_safe_rect.size.x < MatchController.FULL_ARENA.size.x and match_controller.closure_walls.size() == 4, "paredes fecham gradualmente após início configurado")
	check(item.is_queued_for_deletion(), "fechamento remove item coberto")
	check(match_controller.current_safe_rect.has_point(arena.player.position), "personagem é conduzido para área segura")
	await physics_frame
	var wall_query := PhysicsRayQueryParameters2D.create(Vector2(150, 360), Vector2(60, 360), 2)
	var wall_hit := arena.get_world_2d().direct_space_state.intersect_ray(wall_query)
	check(not wall_hit.is_empty() and wall_hit["collider"] in match_controller.closure_walls, "parede de fechamento bloqueia fisicamente")
	arena.player.position = Vector2(150, 360)
	arena.player.facing = Vector2.LEFT
	check(not arena.perform_attack(), "ataque contra parede de fechamento não causa erro")
	match_controller.advance(15.0)
	check(match_controller.state == "results" and match_controller.result["winner"] == "Empate por tempo" and match_controller.result["reason"] == "time_limit", "limite de tempo encerra sem desempate inventado")
	arena.progression.grant_xp(100)
	arena.inventory.pickup_item("health_potion")
	for child in arena.get_children():
		if child is StaticBody2D and child.has_method("take_crate_damage") and child.destructible:
			child.take_crate_damage(999)
			break
	var old_arena = arena
	var restart_touch := InputEventScreenTouch.new()
	restart_touch.pressed = true
	restart_touch.position = Vector2(600, 460)
	arena._input(restart_touch)
	await process_frame
	await process_frame
	check(current_scene != old_arena and current_scene.match_controller.state == "active" and current_scene.progression.level == 1 and current_scene.inventory.slots[0]["id"] == "" and current_scene.wooden_blocks == 12 and current_scene.destroyed_blocks == 0, "botão de resultado inicia partida limpa e restaura caixas")
	remove_arena(current_scene)
	await process_frame
	arena = make_arena(3)
	await physics_frame
	match_controller = arena.match_controller
	arena.inventory.apply_damage(999)
	match_controller.advance(0.0)
	check(match_controller.player_eliminated and match_controller.state == "active" and match_controller.alive_count() == 2, "jogador eliminado não renasce e partida segue")
	var first_spectator := match_controller.spectator_name()
	var second_spectator := match_controller.next_spectator()
	check(first_spectator != second_spectator and first_spectator.begins_with("Bot"), "espectador alterna sobreviventes")
	for bot in arena.combat.bots:
		bot.take_hit(999)
	match_controller.advance(0.0)
	check(match_controller.state == "results" and match_controller.result["winner"] == "Empate", "eliminação simultânea não inventa vencedor")
	remove_arena(arena)
	await process_frame
	if failures == 0:
		print("RELEASE 0.4: todos os testes passaram")
	quit(0 if failures == 0 else 1)
