extends CharacterBody2D

const SWORDSMAN_WALK := {
	"right": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_right.png"),
	"left": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_left.png"),
	"up": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_up.png"),
	"down": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_down.png"),
}
const SWORDSMAN_FRAME_OFFSET := {
	"right": [-59, -41, -20, 2, 29, 47],
	"left": [-50, -36, -16, 9, 29, 46],
	"up": [-56, -46, -25, -2, 21, 44],
	"down": [-57, -47, -24, -9, 20, 42],
}

@export var speed := 260.0
var move_input := Vector2.ZERO
var facing := Vector2.RIGHT
var damage_flash := 0.0
var attack_visual := 0.0
var visual_class := "paladin"
var visual_dead := false
var visual_time := 0.0
var visual_sprite: Sprite2D
var visual_direction := "right"
var skill_flash := 0.0
var skill_kind := -1
var protection_active := false
var determination_active := false

func set_visual_class(id: String) -> void:
	if id == visual_class:
		return
	visual_class = id
	if visual_sprite != null:
		apply_visual_class()

func apply_visual_class() -> void:
	if visual_class == "paladin":
		visual_sprite.z_index = 0
		visual_sprite.texture = SWORDSMAN_WALK[visual_direction]
		visual_sprite.hframes = 6
		visual_sprite.vframes = 1
		visual_sprite.scale = Vector2(0.5, 0.5)
		visual_sprite.position = Vector2(0, -32)
		visual_sprite.offset = Vector2(SWORDSMAN_FRAME_OFFSET[visual_direction][0], 0)
	else:
		visual_sprite.z_index = 0
		visual_sprite.texture = load("res://assets/pixel/%s.png" % visual_class)
		visual_sprite.hframes = 4
		visual_sprite.vframes = 5
		visual_sprite.scale = Vector2.ONE
		visual_sprite.position = Vector2.ZERO
		visual_sprite.offset = Vector2.ZERO
	visual_sprite.frame = 0

func facing_direction() -> String:
	if absf(facing.x) >= absf(facing.y):
		return "right" if facing.x >= 0.0 else "left"
	return "down" if facing.y >= 0.0 else "up"

func show_attack() -> void:
	attack_visual = 0.24

func show_damage() -> void:
	damage_flash = 0.35
	queue_redraw()

func show_skill(index: int) -> void:
	skill_kind = index
	skill_flash = 0.65
	queue_redraw()

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2
	z_index = 2
	visual_sprite = Sprite2D.new()
	visual_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(visual_sprite)
	apply_visual_class()

func _physics_process(delta: float) -> void:
	damage_flash = maxf(0.0, damage_flash - delta)
	attack_visual = maxf(0.0, attack_visual - delta)
	skill_flash = maxf(0.0, skill_flash - delta)
	visual_time += delta
	velocity = move_input.normalized() * speed
	move_and_slide()
	if move_input.length_squared() > 0.01:
		facing = move_input.normalized()
	if visual_class == "paladin":
		var next_direction := facing_direction()
		if next_direction != visual_direction:
			visual_direction = next_direction
			visual_sprite.texture = SWORDSMAN_WALK[visual_direction]
		visual_sprite.frame = 0 if visual_dead or damage_flash > 0.0 or move_input.length_squared() <= 0.01 else 2 if attack_visual > 0.0 else int(visual_time * 8.0) % 6
		visual_sprite.offset.x = SWORDSMAN_FRAME_OFFSET[visual_direction][visual_sprite.frame]
		visual_sprite.modulate = Color(0.55, 0.55, 0.55, 0.7) if visual_dead else Color("ffaaa4") if damage_flash > 0.0 else Color("fff0c0") if attack_visual > 0.0 else Color.WHITE
		visual_sprite.flip_h = false
	else:
		var row := 4 if visual_dead else 3 if damage_flash > 0.0 else 2 if attack_visual > 0.0 else 1 if move_input.length_squared() > 0.01 else 0
		visual_sprite.frame_coords = Vector2i(int(visual_time * 7.0) % 4, row)
		visual_sprite.modulate = Color.WHITE
		visual_sprite.flip_h = facing.x < -0.1
	queue_redraw()

func _draw() -> void:
	if visual_class != "paladin":
		draw_ellipse_shadow()
		return
	var pulse := 0.65 + 0.2 * sin(visual_time * 11.0)
	if protection_active or (skill_kind == 0 and skill_flash > 0.0):
		draw_arc(Vector2(0, -7), 38, -PI * 0.85, PI * 0.85, 32, Color(1.0, 0.78, 0.25, pulse), 4.0)
		draw_colored_polygon(PackedVector2Array([Vector2(0, -29), Vector2(22, -20), Vector2(19, 12), Vector2(0, 30), Vector2(-19, 12), Vector2(-22, -20)]), Color(1.0, 0.76, 0.12, 0.22))
		draw_arc(Vector2(0, -3), 25, 0, TAU, 24, Color("ffe49b"), 2.0)
	if skill_kind == 1 and skill_flash > 0.0:
		var strength := skill_flash / 0.65
		draw_arc(Vector2(0, 18), 22 + (1.0 - strength) * 25, 0, TAU, 32, Color(0.33, 1.0, 0.47, strength * 0.85), 4.0)
		for i in range(6):
			var p := Vector2(-28 + i * 11, 20 - fmod(visual_time * 80.0 + i * 17.0, 65.0))
			draw_line(p + Vector2(-5, 0), p + Vector2(5, 0), Color(0.65, 1.0, 0.65, strength), 3.0)
			draw_line(p + Vector2(0, -5), p + Vector2(0, 5), Color(0.65, 1.0, 0.65, strength), 3.0)
	if determination_active or (skill_kind == 2 and skill_flash > 0.0):
		draw_arc(Vector2(0, 15), 28 + pulse * 6.0, PI, TAU, 20, Color(1.0, 0.7, 0.15, pulse), 4.0)
		for i in range(7):
			var x := -27.0 + i * 9.0
			var height := 16.0 + 13.0 * (0.5 + 0.5 * sin(visual_time * 13.0 + i * 1.7))
			draw_line(Vector2(x, 27), Vector2(x + 3, 27 - height), Color(1.0, 0.68, 0.12, pulse), 3.0)

func draw_ellipse_shadow() -> void:
	draw_circle(Vector2(0, 16), 20, Color("13232a88"))
