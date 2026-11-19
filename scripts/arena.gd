extends Node2D

signal restart_requested
signal menu_requested

const PlayerScene = preload("res://scenes/player.tscn")
const CrateScene = preload("res://scenes/crate.tscn")
const WallScene = preload("res://scenes/wall.tscn")
const GroundItemScene = preload("res://scenes/ground_item.tscn")
const CombatRules = preload("res://scripts/combat_rules.gd")
const ProgressionScript = preload("res://scripts/progression.gd")
const InventoryScript = preload("res://scripts/player_inventory.gd")
const CombatScript = preload("res://scripts/combat_system.gd")
const MatchScript = preload("res://scripts/match_controller.gd")
const GameAudioScript = preload("res://scripts/game_audio.gd")
const ARENA := Rect2(52, 52, 1176, 616)
const SPAWNS := [Vector2(150, 150), Vector2(1130, 150), Vector2(150, 570), Vector2(1130, 570)]

@export var balance: GameBalance = preload("res://resources/balance.tres")
@export var class_balance: ClassBalance = preload("res://resources/classes.tres")
@export var match_settings: MatchSettings = preload("res://resources/match.tres")
@export_range(0, 30, 1) var test_level := 0
@export var enable_debug_controls := true
@export var allow_class_change := true
@export var attack_interval := 0.42
@export var attack_range := 92.0

var player
var progression
var inventory
var combat
var match_controller: MatchController
var rng := RandomNumberGenerator.new()
var debug_item_index := 0
var wooden_blocks := 0
var destroyed_blocks := 0
var attack_held := false
var attack_timer := 0.0
var attack_flash := 0.0
var attack_end := Vector2.ZERO
var joystick_touch := -1
var attack_touch := -1
var joystick_origin := Vector2.ZERO
var joystick_value := Vector2.ZERO
var hud: Label
var status_hud: Label
var effects_hud: Label
var game_audio
var previous_hp := -1
var previous_match_state := ""
const ATTACK_CENTER := Vector2(1140, 570)
const ATTACK_TOUCH_RADIUS := 72.0

func _ready() -> void:
	rng.randomize()
	progression = ProgressionScript.new()
	progression.configure(balance)
	add_child(progression)
	inventory = InventoryScript.new()
	inventory.configure(balance)
	add_child(inventory)
	create_obstacles()
	player = PlayerScene.instantiate()
	player.position = SPAWNS[0]
	add_child(player)
	combat = CombatScript.new()
	add_child(combat)
	combat.configure(self, player, inventory, progression, class_balance)
	match_controller = MatchScript.new()
	add_child(match_controller)
	match_controller.configure(self, combat, inventory, progression, match_settings)
	game_audio = GameAudioScript.new()
	add_child(game_audio)
	previous_hp = inventory.hp
	previous_match_state = match_controller.state
	hud = Label.new()
	hud.position = Vector2(24, 9)
	hud.add_theme_font_size_override("font_size", 18)
	hud.add_theme_color_override("font_color", Color("f3f0df"))
	add_child(hud)
	status_hud = Label.new()
	status_hud.position = Vector2(480, 8)
	status_hud.add_theme_font_size_override("font_size", 19)
	status_hud.add_theme_color_override("font_color", Color("fff1b3"))
	add_child(status_hud)
	effects_hud = Label.new()
	effects_hud.position = Vector2(24, 130)
	effects_hud.add_theme_font_size_override("font_size", 15)
	effects_hud.add_theme_color_override("font_color", Color("bde3d6"))
	add_child(effects_hud)
	update_hud()
	queue_redraw()

func create_obstacles() -> void:
	for wall in [
		[Vector2(640, 36), Vector2(1208, 32)],
		[Vector2(640, 684), Vector2(1208, 32)],
		[Vector2(36, 360), Vector2(32, 648)],
		[Vector2(1244, 360), Vector2(32, 648)],
		[Vector2(275, 180), Vector2(75, 52)],
		[Vector2(1005, 180), Vector2(75, 52)],
		[Vector2(275, 540), Vector2(75, 52)],
		[Vector2(1005, 540), Vector2(75, 52)],
		[Vector2(600, 155), Vector2(110, 48)],
		[Vector2(720, 565), Vector2(80, 65)]]:
		add_obstacle(WallScene, wall[0], wall[1])
	for pos in [
		Vector2(194, 290), Vector2(410, 176), Vector2(490, 310),
		Vector2(762, 223), Vector2(1090, 286), Vector2(270, 385),
		Vector2(440, 470), Vector2(583, 538), Vector2(810, 425),
		Vector2(944, 365), Vector2(1095, 438), Vector2(690, 122)]:
		add_obstacle(CrateScene, pos, Vector2(68, 68))

func add_obstacle(scene: PackedScene, at_position: Vector2, at_size: Vector2) -> void:
	var obstacle = scene.instantiate()
	obstacle.position = at_position
	obstacle.size = at_size
	add_child(obstacle)
	if obstacle.destructible:
		wooden_blocks += 1
		obstacle.destroyed.connect(on_block_destroyed)

func on_block_destroyed(obstacle: StaticBody2D) -> void:
	wooden_blocks -= 1
	destroyed_blocks += 1
	progression.grant_xp(balance.xp_per_crate, inventory.xp_multiplier())
	if rng.randf() < balance.drop_chance:
		var item_id := choose_drop()
		if item_id != "":
			spawn_ground_item(item_id, obstacle.position)
	update_hud()

func choose_drop() -> String:
	var total := 0
	for item_id in InventoryScript.ITEM_IDS:
		total += maxi(0, int(balance.drop_weights.get(item_id, 0)))
	if total <= 0:
		return ""
	var choice := rng.randi_range(1, total)
	for item_id in InventoryScript.ITEM_IDS:
		choice -= maxi(0, int(balance.drop_weights.get(item_id, 0)))
		if choice <= 0:
			return item_id
	return ""

func spawn_ground_item(item_id: String, at_position: Vector2) -> GroundItem:
	var item: GroundItem = GroundItemScene.instantiate()
	item.configure(item_id, balance.ground_item_lifetime)
	item.position = at_position
	add_child(item)
	return item

func collect_ground_items() -> void:
	for child in get_children():
		if child is GroundItem and not child.is_queued_for_deletion():
			if player.position.distance_to(child.position) <= balance.pickup_radius:
				if inventory.pickup_item(child.item_id):
					game_audio.play_cue("pickup")
					child.queue_free()

# Chamada reservada para o fechamento da arena na release 0.4.
func remove_items_outside(playable_rect: Rect2) -> void:
	for child in get_children():
		if child is GroundItem and not playable_rect.has_point(child.position):
			child.queue_free()

func debug_spawn_next_item() -> void:
	if not enable_debug_controls:
		return
	var item_id: String = InventoryScript.ITEM_IDS[debug_item_index % InventoryScript.ITEM_IDS.size()]
	debug_item_index += 1
	spawn_ground_item(item_id, player.position)

func debug_take_damage() -> void:
	if enable_debug_controls:
		inventory.apply_damage(25)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		restart_game()
		return
	if match_controller.state == "results" or inventory.hp <= 0:
		player.move_input = Vector2.ZERO
		player.visual_dead = inventory.hp <= 0
		attack_held = false
		if match_controller.state == "active":
			match_controller.advance(delta)
		update_feedback()
		update_hud()
		queue_redraw()
		return
	var keys := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction: Vector2 = joystick_value if joystick_touch >= 0 else keys
	player.move_input = direction
	player.set_visual_class(combat.class_id)
	player.speed = float(combat.stats()["speed"]) * inventory.movement_speed_multiplier() * combat.speed_multiplier()
	if direction.length_squared() > 0.01:
		player.facing = direction.normalized()
	if attack_touch < 0:
		attack_held = Input.is_action_pressed("attack")
	attack_timer = maxf(0.0, attack_timer - delta)
	attack_flash = maxf(0.0, attack_flash - delta)
	if attack_held and attack_timer <= 0.0:
		var attacked_crate := perform_attack()
		attack_timer = attack_interval if attacked_crate or test_level > 0 else float(combat.stats()["interval"])
	inventory.advance(delta)
	combat.advance(delta)
	match_controller.advance(delta)
	collect_ground_items()
	update_feedback()
	update_hud()
	queue_redraw()

func update_feedback() -> void:
	if inventory.hp < previous_hp:
		game_audio.play_cue("hit")
	if match_controller.state == "results" and previous_match_state != "results":
		game_audio.play_cue("elimination")
	previous_hp = inventory.hp
	previous_match_state = match_controller.state

func perform_attack() -> bool:
	var start: Vector2 = player.position + player.facing * 24.0
	var end: Vector2 = player.position + player.facing * attack_range
	var query := PhysicsRayQueryParameters2D.create(start, end, 2, [player.get_rid()])
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	attack_end = hit.get("position", end)
	attack_flash = 0.12
	player.show_attack()
	if not hit.is_empty() and hit["collider"] is StaticBody2D and hit["collider"].has_method("take_crate_damage") and hit["collider"].destructible:
		var damage_level: int = test_level if test_level > 0 else progression.level
		hit["collider"].take_crate_damage(CombatRules.crate_damage(damage_level))
		game_audio.play_cue("hit")
		return true
	else:
		combat.fire_basic()
	return false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode == KEY_M:
			menu_requested.emit()
		elif event.physical_keycode >= KEY_1 and event.physical_keycode <= KEY_4:
			inventory.use_slot(event.physical_keycode - KEY_1)
		elif event.physical_keycode == KEY_H:
			debug_take_damage()
		elif event.physical_keycode == KEY_J:
			debug_spawn_next_item()
		elif event.physical_keycode == KEY_T and enable_debug_controls:
			match_controller.advance(60.0)
		elif event.physical_keycode == KEY_TAB and match_controller.player_eliminated:
			match_controller.next_spectator()
		elif event.physical_keycode == KEY_TAB and allow_class_change and match_controller.state == "active":
			var classes := ["paladin", "mage", "assassin", "archer"]
			combat.select_class(classes[(classes.find(combat.class_id) + 1) % classes.size()])
		elif event.physical_keycode in [KEY_Q, KEY_E, KEY_F] and match_controller.state == "active" and inventory.hp > 0:
			if combat.use_skill([KEY_Q, KEY_E, KEY_F].find(event.physical_keycode)):
				game_audio.play_cue("skill")
	elif event is InputEventScreenTouch:
		if event.pressed:
			if match_controller.state == "results" and Rect2(480, 430, 320, 70).has_point(event.position):
				restart_game()
			elif Rect2(958, 250, 240, 52).has_point(event.position):
				menu_requested.emit()
			elif enable_debug_controls and Rect2(958, 190, 240, 52).has_point(event.position):
				match_controller.advance(60.0)
			elif event.position.y >= 65 and event.position.y <= 122 and event.position.x >= 24 and event.position.x < 444:
				var slot_index := int((event.position.x - 24.0) / 105.0)
				inventory.use_slot(slot_index)
			elif event.position.y >= 65 and event.position.y <= 122 and event.position.x >= 958 and event.position.x < 1058:
				debug_take_damage()
			elif event.position.y >= 65 and event.position.y <= 122 and event.position.x >= 1070 and event.position.x < 1198:
				debug_spawn_next_item()
			elif event.position.y >= 125 and event.position.y <= 177 and event.position.x >= 1055 and event.position.x < 1198 and match_controller.player_eliminated:
				match_controller.next_spectator()
			elif event.position.y >= 125 and event.position.y <= 177 and event.position.x >= 1055 and event.position.x < 1198 and allow_class_change and match_controller.state == "active":
				var classes := ["paladin", "mage", "assassin", "archer"]
				combat.select_class(classes[(classes.find(combat.class_id) + 1) % classes.size()])
			elif event.position.y >= 600 and event.position.y <= 668 and event.position.x >= 730 and event.position.x < 1054 and match_controller.state == "active" and inventory.hp > 0:
				if combat.use_skill(int((event.position.x - 730.0) / 108.0)):
					game_audio.play_cue("skill")
			elif event.position.x < 400 and joystick_touch < 0:
				joystick_touch = event.index
				joystick_origin = event.position
				joystick_value = Vector2.ZERO
			elif event.position.distance_to(ATTACK_CENTER) < ATTACK_TOUCH_RADIUS and attack_touch < 0:
				attack_touch = event.index
				attack_held = true
		else:
			if event.index == joystick_touch:
				joystick_touch = -1
				joystick_value = Vector2.ZERO
			if event.index == attack_touch:
				attack_touch = -1
				attack_held = false
	elif event is InputEventScreenDrag and event.index == joystick_touch:
		joystick_value = (event.position - joystick_origin).limit_length(72) / 72.0

func update_hud() -> void:
	if hud == null or progression == null or inventory == null:
		return
	var next_xp := "MAX" if progression.level >= balance.max_level else str(progression.xp_to_next())
	var buffs: Array[String] = []
	for item_id in ["strength", "speed", "shield", "xp_amulet"]:
		if inventory.effect_remaining(item_id) > 0.0:
			var label_text: String = item_id.substr(0, 1).to_upper() + " %.0fs" % inventory.effect_remaining(item_id)
			if item_id == "shield":
				label_text += "/%d" % inventory.shield_points
			buffs.append(label_text)
	var buff_text := ", ".join(buffs) if not buffs.is_empty() else "nenhum"
	var test_text := " (teste %d)" % test_level if test_level > 0 else ""
	hud.text = "HP %d/%d   Nível %d%s   XP %d/%s\nCaixas destruídas: %d   Restantes: %d" % [inventory.hp, inventory.maximum_hp(), progression.level, test_text, progression.xp, next_xp, destroyed_blocks, wooden_blocks]
	status_hud.text = match_controller.status_text()
	effects_hud.text = "%s  |  Efeitos: %s  |  Uso: %.1fs" % [combat.class_id.capitalize(), buff_text, inventory.use_cooldown]

func restart_game() -> void:
	if restart_requested.has_connections():
		restart_requested.emit()
	else:
		get_tree().call_deferred("reload_current_scene")

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), Color("192d2d"))
	draw_rect(ARENA, Color("304b42"))
	draw_rect(Rect2(0, 0, 1280, 52), Color("13242be8"))
	draw_rect(Rect2(12, 58, 438, 69), Color("13242bdc"))
	draw_rect(Rect2(12, 125, 440, 32), Color("13242bdc"))
	if match_controller != null and match_controller.elapsed >= match_settings.shrink_start:
		var safe: Rect2 = match_controller.current_safe_rect
		var shade := Color(0.65, 0.1, 0.1, 0.56)
		for strip in [Rect2(ARENA.position, Vector2(ARENA.size.x, safe.position.y - ARENA.position.y)), Rect2(Vector2(ARENA.position.x, safe.end.y), Vector2(ARENA.size.x, ARENA.end.y - safe.end.y)), Rect2(Vector2(ARENA.position.x, safe.position.y), Vector2(safe.position.x - ARENA.position.x, safe.size.y)), Rect2(Vector2(safe.end.x, safe.position.y), Vector2(ARENA.end.x - safe.end.x, safe.size.y))]:
			draw_rect(strip, shade)
	for x in range(80, 1230, 80):
		draw_line(Vector2(x, 55), Vector2(x, 665), Color("365449"), 1)
	for y in range(80, 670, 80):
		draw_line(Vector2(55, y), Vector2(1225, y), Color("365449"), 1)
	for spawn in SPAWNS:
		draw_circle(spawn, 63, Color(0.29, 0.52, 0.53, 0.3))
		draw_arc(spawn, 63, 0, TAU, 48, Color("6ca69c"), 2)
	if inventory != null:
		for i in range(inventory.slots.size()):
			var slot: Dictionary = inventory.slots[i]
			var origin := Vector2(24 + i * 105, 66)
			draw_rect(Rect2(origin, Vector2(98, 54)), Color(0.08, 0.14, 0.16, 0.85))
			draw_rect(Rect2(origin, Vector2(98, 54)), Color("79bcb0"), false, 2)
			var item_text: String = "vazio" if slot["id"] == "" else slot["id"].replace("health_potion", "Poção").replace("strength", "Força").replace("speed", "Botas").replace("shield", "Escudo").replace("elixir", "Elixir")
			draw_string(ThemeDB.fallback_font, origin + Vector2(7, 22), "%d %s" % [i + 1, item_text], HORIZONTAL_ALIGNMENT_LEFT, 90, 15, Color("f3f0df"))
			if slot["quantity"] > 1:
				draw_string(ThemeDB.fallback_font, origin + Vector2(74, 46), "x%d" % slot["quantity"], HORIZONTAL_ALIGNMENT_LEFT, 25, 15, Color("ffe0a0"))
	if enable_debug_controls:
		for button in [[Rect2(958, 66, 100, 54), "H Dano"], [Rect2(1070, 66, 128, 54), "J Item"]]:
			draw_rect(button[0], Color(0.16, 0.2, 0.25, 0.88))
			draw_rect(button[0], Color("d6b77b"), false, 2)
			draw_string(ThemeDB.fallback_font, button[0].position + Vector2(10, 32), button[1], HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("f3f0df"))
		if allow_class_change or match_controller != null and match_controller.player_eliminated:
			draw_rect(Rect2(1055, 125, 143, 52), Color("283d48"))
			draw_string(ThemeDB.fallback_font, Vector2(1064, 157), "TAB Ver" if match_controller != null and match_controller.player_eliminated else "TAB Classe", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("f3f0df"))
		draw_rect(Rect2(958, 190, 240, 52), Color("283d48"))
		draw_string(ThemeDB.fallback_font, Vector2(968, 223), "T +60s teste", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("f3f0df"))
	draw_rect(Rect2(958, 250, 240, 52), Color("283d48"))
	draw_string(ThemeDB.fallback_font, Vector2(968, 283), "M Menu", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("f3f0df"))
	for i in range(3):
		var box := Rect2(730 + i * 108, 600, 98, 68)
		draw_rect(box, Color("284758"))
		draw_rect(box, Color("a5c6c7"), false, 2)
		draw_string(ThemeDB.fallback_font, box.position + Vector2(12, 28), ["Q", "E", "F"][i], HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("f3f0df"))
		if combat != null:
			draw_string(ThemeDB.fallback_font, box.position + Vector2(36, 55), "%.0fs" % combat.cooldowns[i] if combat.cooldowns[i] > 0.0 else "PRONTO", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("f0d69c"))
	var base := joystick_origin if joystick_touch >= 0 else Vector2(130, 570)
	draw_circle(base, 73, Color(0.1, 0.17, 0.19, 0.45))
	draw_arc(base, 73, 0, TAU, 48, Color("72b9ab"), 3)
	draw_circle(base + joystick_value * 55, 28, Color(0.34, 0.75, 0.67, 0.7))
	draw_circle(ATTACK_CENTER, 66, Color(0.45, 0.17, 0.13, 0.8))
	draw_arc(ATTACK_CENTER, 66, 0, TAU, 48, Color("e6a66d"), 4)
	draw_string(ThemeDB.fallback_font, ATTACK_CENTER + Vector2(-38, 7), "ATAQUE", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("fff1b3"))
	if attack_flash > 0.0 and player != null:
		draw_line(player.position + player.facing * 24, attack_end, Color("ffe0a0"), 12, true)
	if match_controller != null and match_controller.state == "results":
		draw_rect(Rect2(350, 250, 580, 290), Color(0.05, 0.1, 0.14, 0.96))
		draw_rect(Rect2(350, 250, 580, 290), Color("d6b77b"), false, 4)
		draw_string(ThemeDB.fallback_font, Vector2(400, 310), "RESULTADO: %s" % match_controller.result["winner"], HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color("fff1b3"))
		draw_string(ThemeDB.fallback_font, Vector2(400, 365), "Nível %d  |  XP %d  |  Caixas %d" % [match_controller.result["level"], match_controller.result["xp"], match_controller.result["crates"]], HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("f3f0df"))
		draw_rect(Rect2(480, 430, 320, 70), Color("356f63"))
		draw_string(ThemeDB.fallback_font, Vector2(515, 475), "Nova partida (R)", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("f3f0df"))
