extends Node2D

const PlayerScene = preload("res://scenes/player.tscn")
const CrateScene = preload("res://scenes/crate.tscn")
const WallScene = preload("res://scenes/wall.tscn")
const CombatRules = preload("res://scripts/combat_rules.gd")
const ARENA := Rect2(52, 52, 1176, 616)
const SPAWNS := [Vector2(150, 150), Vector2(1130, 150), Vector2(150, 570), Vector2(1130, 570)]

@export_range(1, 30, 1) var test_level := 1
@export var attack_interval := 0.42
@export var attack_range := 92.0

var player
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

func _ready() -> void:
	create_obstacles()
	player = PlayerScene.instantiate()
	player.position = SPAWNS[0]
	add_child(player)
	hud = Label.new()
	hud.position = Vector2(22, 12)
	hud.add_theme_font_size_override("font_size", 21)
	hud.add_theme_color_override("font_color", Color("f3f0df"))
	add_child(hud)
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

func on_block_destroyed(_obstacle: StaticBody2D) -> void:
	wooden_blocks -= 1
	destroyed_blocks += 1
	update_hud()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().call_deferred("reload_current_scene")
		return
	var keys := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction: Vector2 = joystick_value if joystick_touch >= 0 else keys
	player.move_input = direction
	if direction.length_squared() > 0.01:
		player.facing = direction.normalized()
	if attack_touch < 0:
		attack_held = Input.is_action_pressed("attack")
	attack_timer = maxf(0.0, attack_timer - delta)
	attack_flash = maxf(0.0, attack_flash - delta)
	if attack_held and attack_timer <= 0.0:
		perform_attack()
		attack_timer = attack_interval
	queue_redraw()

func perform_attack() -> void:
	var start: Vector2 = player.position + player.facing * 24.0
	var end: Vector2 = player.position + player.facing * attack_range
	var query := PhysicsRayQueryParameters2D.create(start, end, 2, [player.get_rid()])
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	attack_end = hit.get("position", end)
	attack_flash = 0.12
	if not hit.is_empty() and hit["collider"].destructible:
		hit["collider"].take_crate_damage(CombatRules.crate_damage(test_level))

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.x < 400 and joystick_touch < 0:
				joystick_touch = event.index
				joystick_origin = event.position
				joystick_value = Vector2.ZERO
			elif event.position.distance_to(Vector2(1130, 570)) < 110 and attack_touch < 0:
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
	if hud != null:
		hud.text = "RAGNARENA  |  Nível de teste: %d  |  Caixas destruídas: %d  |  Restantes: %d\nWASD/setas: mover   Espaço: atacar   R: reiniciar" % [test_level, destroyed_blocks, wooden_blocks]

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), Color("192d2d"))
	draw_rect(ARENA, Color("304b42"))
	for x in range(80, 1230, 80):
		draw_line(Vector2(x, 55), Vector2(x, 665), Color("365449"), 1)
	for y in range(80, 670, 80):
		draw_line(Vector2(55, y), Vector2(1225, y), Color("365449"), 1)
	for spawn in SPAWNS:
		draw_circle(spawn, 63, Color(0.29, 0.52, 0.53, 0.3))
		draw_arc(spawn, 63, 0, TAU, 48, Color("6ca69c"), 2)
	var base := joystick_origin if joystick_touch >= 0 else Vector2(130, 570)
	draw_circle(base, 73, Color(0.1, 0.17, 0.19, 0.45))
	draw_arc(base, 73, 0, TAU, 48, Color("72b9ab"), 3)
	draw_circle(base + joystick_value * 55, 28, Color(0.34, 0.75, 0.67, 0.7))
	draw_circle(Vector2(1130, 570), 66, Color(0.45, 0.17, 0.13, 0.65))
	draw_arc(Vector2(1130, 570), 66, 0, TAU, 48, Color("e6a66d"), 4)
	if attack_flash > 0.0 and player != null:
		draw_line(player.position + player.facing * 24, attack_end, Color("ffe0a0"), 12, true)
