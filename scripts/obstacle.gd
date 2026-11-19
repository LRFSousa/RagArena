extends StaticBody2D

signal destroyed(obstacle: StaticBody2D)

@export var destructible := false
@export var max_hp := 45
@export var size := Vector2(68, 68)
var hp := 45

func _ready() -> void:
	hp = max_hp
	collision_layer = 2
	collision_mask = 0
	var shape := RectangleShape2D.new()
	shape.size = size
	$CollisionShape2D.shape = shape
	queue_redraw()

func take_crate_damage(amount: int) -> void:
	if not destructible or amount <= 0:
		return
	hp = maxi(0, hp - amount)
	if hp == 0:
		destroyed.emit(self)
		queue_free()
	else:
		queue_redraw()

func _draw() -> void:
	var rect := Rect2(-size * 0.5, size)
	if destructible:
		draw_rect(rect, Color("9a653b"))
		draw_rect(rect.grow(-6), Color("c58b4d"), false, 4)
		draw_line(Vector2(-size.x * 0.25, -size.y * 0.35), Vector2(-size.x * 0.25, size.y * 0.35), Color("6f422b"), 3)
		draw_line(Vector2(size.x * 0.2, -size.y * 0.35), Vector2(size.x * 0.2, size.y * 0.35), Color("6f422b"), 3)
		if hp < max_hp:
			var ratio := float(hp) / float(max_hp)
			draw_rect(Rect2(Vector2(-size.x * 0.5, -size.y * 0.5 - 11), Vector2(size.x * ratio, 5)), Color("e8c66b"))
	else:
		draw_rect(rect, Color("4d5660"))
		draw_rect(rect.grow(-6), Color("77828d"), false, 4)
		draw_line(Vector2(-size.x * 0.35, 0), Vector2(size.x * 0.35, 0), Color("313941"), 3)
