extends Node
class_name MatchController

signal match_ended(result: Dictionary)
signal participation_ended(report: Dictionary)

const MapLayout = preload("res://scripts/arena_map_layout.gd")
const FULL_ARENA := MapLayout.PLAYABLE_RECT
const SPAWNS := MapLayout.SPAWNS

var settings: MatchSettings
var arena: Node2D
var combat: CombatSystem
var inventory: PlayerInventory
var progression: MatchProgression
var state := "preparing"
var elapsed := 0.0
var result: Dictionary = {}
var spectator_index := 0
var current_safe_rect := FULL_ARENA
var closure_walls: Array[StaticBody2D] = []
var last_wall_update := -1.0
var player_eliminated := false
var match_id := ""
var player_kills := 0
var player_assists := 0
var effective_skill_uses: Dictionary = {}
var credited_victims: Dictionary = {}
var credited_assists: Dictionary = {}

func configure(owner_arena: Node2D, fight: CombatSystem, bag: PlayerInventory, levels: MatchProgression, rules: MatchSettings) -> void:
	arena = owner_arena
	combat = fight
	inventory = bag
	progression = levels
	settings = rules
	state = "preparing"
	elapsed = 0.0
	result.clear()
	current_safe_rect = FULL_ARENA
	player_eliminated = false
	match_id = Crypto.new().generate_random_bytes(16).hex_encode()
	player_kills = 0
	player_assists = 0
	effective_skill_uses.clear()
	credited_victims.clear()
	credited_assists.clear()
	for wall in closure_walls:
		wall.queue_free()
	closure_walls.clear()
	for bot in combat.bots:
		bot.queue_free()
	combat.bots.clear()
	combat.player.position = SPAWNS[0]
	progression.configure(inventory.balance)
	inventory.configure(inventory.balance)
	combat.select_class(combat.class_id)
	for i in range(1, clampi(settings.participants, 2, 5)):
		combat.spawn_bot(SPAWNS[i])
	state = "active"

func alive_count() -> int:
	var count := 1 if inventory.hp > 0 else 0
	for bot in combat.bots:
		if bot.active:
			count += 1
	return count

func alive_names() -> Array[String]:
	var names: Array[String] = []
	if inventory.hp > 0:
		names.append("Jogador")
	for i in range(combat.bots.size()):
		if combat.bots[i].active:
			names.append("Bot %d" % (i + 1))
	return names

func advance(delta: float) -> void:
	if state != "active":
		return
	elapsed += maxf(0.0, delta)
	if inventory.hp <= 0:
		player_eliminated = true
		state = "results"
		result = participation_report("defeat", "")
		participation_ended.emit(result)
		return
	var names := alive_names()
	if names.size() <= 1:
		finish("last_survivor", names[0] if names.size() == 1 else "Empate")
		return
	if elapsed >= settings.time_limit:
		# Sem regra de desempate aprovada: registrar empate por tempo.
		finish("time_limit", "Empate por tempo")
		return
	if elapsed >= settings.shrink_start and elapsed - last_wall_update >= settings.wall_update_interval:
		update_closure()
		last_wall_update = elapsed

func finish(reason: String, winner: String) -> void:
	if state != "active":
		return
	state = "results"
	result = participation_report(reason, winner)
	result.merge({
		"reason": reason,
		"winner": winner,
		"survivors": alive_names(),
		"level": progression.level,
		"xp": progression.total_xp,
		"crates": arena.destroyed_blocks,
		"participants": settings.participants,
	}, true)
	match_ended.emit(result)

func participation_report(reason: String, winner: String) -> Dictionary:
	var has_winner := winner != "" and winner != "Empate" and winner != "Empate por tempo"
	return {"match_id": match_id, "active_seconds": elapsed, "arena_limit_seconds": settings.time_limit, "kills": player_kills, "assists": player_assists, "effective_skills": effective_skill_uses.size(), "dead": inventory.hp <= 0, "abandoned": reason == "abandon", "completed_with_winner": has_winner, "won": winner == "Jogador", "elapsed": elapsed, "winner": winner, "reason": reason, "level": progression.level, "xp": progression.total_xp, "crates": arena.destroyed_blocks}

func register_elimination(victim_id: int) -> void:
	if state != "active" or credited_victims.has(victim_id):
		return
	credited_victims[victim_id] = true
	if credited_assists.erase(victim_id):
		player_assists = maxi(0, player_assists - 1)
	player_kills += 1

func register_assist(victim_id: int) -> void:
	if state != "active" or credited_assists.has(victim_id) or credited_victims.has(victim_id):
		return
	credited_assists[victim_id] = true
	player_assists += 1

func register_effective_skill(use_id: int) -> void:
	if state == "active" and use_id > 0:
		effective_skill_uses[use_id] = true

func spectator_name() -> String:
	var names := alive_names()
	if names.is_empty():
		return "Ninguém"
	return names[posmod(spectator_index, names.size())]

func next_spectator() -> String:
	spectator_index += 1
	return spectator_name()

func status_text() -> String:
	if state == "results":
		if result.has("permanent_reward"):
			var paid: Dictionary = result["permanent_reward"]
			return "FIM — %s | Base EXP +%d | Job EXP +%d | R: outra partida" % [result["winner"], paid.get("base_awarded", 0), paid.get("job_awarded", 0)]
		return "FIM — %s | Nível %d | XP %d | Caixas %d | R: outra partida" % [result["winner"], result["level"], result["xp"], result["crates"]]
	var remaining := maxi(0, ceili(settings.time_limit - elapsed))
	var stage := ""
	if elapsed >= settings.shrink_start:
		stage = " | Arena fechando"
	elif elapsed >= settings.shrink_start - settings.warning_lead:
		stage = " | Atenção: arena fechará em %ds" % ceili(settings.shrink_start - elapsed)
	if player_eliminated:
		stage += " | Espectador: %s (Tab)" % spectator_name()
	return "Partida %02d:%02d | Vivos %d/%d%s" % [int(remaining / 60), remaining % 60, alive_count(), settings.participants, stage]

func update_closure() -> void:
	current_safe_rect = settings.safe_rect(FULL_ARENA, elapsed)
	arena.remove_items_outside(current_safe_rect)
	for actor in [combat.player] + combat.bots:
		if actor == combat.player and inventory.hp <= 0:
			continue
		if actor is CombatBot and not actor.active:
			continue
		# O aviso precede o fechamento; atores alcançados são deslocados para a borda segura.
		actor.position = Vector2(
			clampf(actor.position.x, current_safe_rect.position.x + 24.0, current_safe_rect.end.x - 24.0),
			clampf(actor.position.y, current_safe_rect.position.y + 24.0, current_safe_rect.end.y - 24.0))
	ensure_walls()
	var rect := current_safe_rect
	var strips := [
		Rect2(FULL_ARENA.position, Vector2(FULL_ARENA.size.x, rect.position.y - FULL_ARENA.position.y)),
		Rect2(Vector2(FULL_ARENA.position.x, rect.end.y), Vector2(FULL_ARENA.size.x, FULL_ARENA.end.y - rect.end.y)),
		Rect2(Vector2(FULL_ARENA.position.x, rect.position.y), Vector2(rect.position.x - FULL_ARENA.position.x, rect.size.y)),
		Rect2(Vector2(rect.end.x, rect.position.y), Vector2(FULL_ARENA.end.x - rect.end.x, rect.size.y)),
	]
	for i in range(4):
		var strip: Rect2 = strips[i]
		closure_walls[i].position = strip.get_center()
		var collider: CollisionShape2D = closure_walls[i].get_node("CollisionShape2D")
		var shape := RectangleShape2D.new()
		shape.size = strip.size
		collider.shape = shape
		closure_walls[i].visible = strip.size.x > 0.0 and strip.size.y > 0.0
		collider.disabled = not closure_walls[i].visible

func ensure_walls() -> void:
	if closure_walls.size() == 4:
		return
	for i in range(4):
		var wall := StaticBody2D.new()
		wall.name = "ClosingWall%d" % i
		wall.collision_layer = 2
		wall.collision_mask = 0
		var collider := CollisionShape2D.new()
		collider.name = "CollisionShape2D"
		wall.add_child(collider)
		arena.add_child(wall)
		closure_walls.append(wall)
