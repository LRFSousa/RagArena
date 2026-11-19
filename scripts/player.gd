extends CharacterBody2D

@export var speed := 260.0
var move_input := Vector2.ZERO
var facing := Vector2.RIGHT

func _ready() -> void:
	collision_layer = 1
	collision_mask = 2

func _physics_process(_delta: float) -> void:
	velocity = move_input.normalized() * speed
	move_and_slide()
	if move_input.length_squared() > 0.01:
		facing = move_input.normalized()
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 22, Color("203946"))
	draw_circle(Vector2.ZERO, 18, Color("55d5c0"))
	draw_line(Vector2.ZERO, facing * 28, Color("fff1b3"), 7, true)
	draw_circle(facing * 28, 4, Color("fff1b3"))
