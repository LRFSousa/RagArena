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

func set_visual_class(id: String) -> void:
	if id == visual_class:
		return
	visual_class = id
	if visual_sprite != null:
		apply_visual_class()

func apply_visual_class() -> void:
	if visual_class == "paladin":
		visual_sprite.texture = SWORDSMAN_WALK[visual_direction]
		visual_sprite.hframes = 6
		visual_sprite.vframes = 1
		visual_sprite.scale = Vector2(0.25, 0.25)
		visual_sprite.offset = Vector2(SWORDSMAN_FRAME_OFFSET[visual_direction][0], 0)
	else:
		visual_sprite.texture = load("res://assets/pixel/%s.png" % visual_class)
		visual_sprite.hframes = 4
		visual_sprite.vframes = 5
		visual_sprite.scale = Vector2.ONE
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

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2
	visual_sprite = Sprite2D.new()
	visual_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(visual_sprite)
	apply_visual_class()

func _physics_process(delta: float) -> void:
	damage_flash = maxf(0.0, damage_flash - delta)
	attack_visual = maxf(0.0, attack_visual - delta)
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

func draw_ellipse_shadow() -> void:
	draw_circle(Vector2(0, 16), 20, Color("13232a88"))
