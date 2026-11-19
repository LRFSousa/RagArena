extends CharacterBody2D
class_name CombatBot

var max_hp := 90
var hp := 90
var frozen := 0.0
var rooted := 0.0
var barrier := 0
var barrier_time := 0.0
var attack_time := 0.0
var knockback := Vector2.ZERO
var active := true

func setup(hit_points: int) -> void:
	max_hp = hit_points
	hp = hit_points

func _ready() -> void:
	collision_layer = 4
	collision_mask = 2
	var collider := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 18
	collider.shape = shape
	add_child(collider)
	queue_redraw()

func _physics_process(delta: float) -> void:
	frozen = maxf(0.0, frozen - delta)
	rooted = maxf(0.0, rooted - delta)
	barrier_time = maxf(0.0, barrier_time - delta)
	attack_time = maxf(0.0, attack_time - delta)
	if barrier_time <= 0.0:
		barrier = 0
	velocity = knockback if frozen <= 0.0 and rooted <= 0.0 else Vector2.ZERO
	knockback = knockback.move_toward(Vector2.ZERO, 600.0 * delta)
	move_and_slide()
	queue_redraw()

func take_hit(amount: int) -> int:
	if not active or amount <= 0:
		return 0
	var absorbed := mini(barrier, amount)
	barrier -= absorbed
	var before := hp
	hp = maxi(0, hp - (amount - absorbed))
	if hp == 0:
		active = false
		collision_layer = 0
	queue_redraw()
	return before - hp

func _draw() -> void:
	draw_circle(Vector2.ZERO, 20, Color("59505c") if active else Color("393b3b"))
	draw_circle(Vector2.ZERO, 15, Color("d8846d") if active else Color("777777"))
	draw_rect(Rect2(-20, -34, 40.0 * hp / max_hp, 5), Color("ed6c6c"))
	if frozen > 0.0 or rooted > 0.0:
		draw_arc(Vector2.ZERO, 23, 0, TAU, 24, Color("8bdaf4"), 3)
