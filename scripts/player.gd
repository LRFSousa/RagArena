extends CharacterBody2D

@export var speed := 260.0
var move_input := Vector2.ZERO
var facing := Vector2.RIGHT
var damage_flash := 0.0
var attack_visual := 0.0
var visual_class := "paladin"
var visual_dead := false
var visual_time := 0.0
var visual_sprite: Sprite2D

func set_visual_class(id: String) -> void:
	if id == visual_class:
		return
	visual_class = id
	if visual_sprite != null:
		visual_sprite.texture = load("res://assets/pixel/%s.png" % id)

func show_attack() -> void:
	attack_visual = 0.24

func show_damage() -> void:
	damage_flash = 0.35
	queue_redraw()

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2
	visual_sprite = Sprite2D.new()
	visual_sprite.texture = load("res://assets/pixel/%s.png" % visual_class)
	visual_sprite.hframes = 4
	visual_sprite.vframes = 5
	visual_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	add_child(visual_sprite)

func _physics_process(delta: float) -> void:
	damage_flash = maxf(0.0, damage_flash - delta)
	attack_visual = maxf(0.0, attack_visual - delta)
	visual_time += delta
	velocity = move_input.normalized() * speed
	move_and_slide()
	if move_input.length_squared() > 0.01:
		facing = move_input.normalized()
	var row := 4 if visual_dead else 3 if damage_flash > 0.0 else 2 if attack_visual > 0.0 else 1 if move_input.length_squared() > 0.01 else 0
	visual_sprite.frame_coords = Vector2i(int(visual_time * 7.0) % 4, row)
	visual_sprite.flip_h = facing.x < -0.1
	queue_redraw()

func _draw() -> void:
	draw_ellipse_shadow()

func draw_ellipse_shadow() -> void:
	draw_circle(Vector2(0, 16), 20, Color("13232a88"))
