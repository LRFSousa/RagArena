extends CharacterBody2D

@export var speed := 260.0
var move_input := Vector2.ZERO
var facing := Vector2.RIGHT
var damage_flash := 0.0

func show_damage() -> void:
	damage_flash = 0.35
	queue_redraw()

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2

func _physics_process(delta: float) -> void:
	damage_flash = maxf(0.0, damage_flash - delta)
	velocity = move_input.normalized() * speed
	move_and_slide()
	if move_input.length_squared() > 0.01:
		facing = move_input.normalized()
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 22, Color("203946"))
	draw_circle(Vector2.ZERO, 18, Color("ff7770") if damage_flash > 0.0 else Color("55d5c0"))
	draw_line(Vector2.ZERO, facing * 28, Color("fff1b3"), 7, true)
	draw_circle(facing * 28, 4, Color("fff1b3"))
