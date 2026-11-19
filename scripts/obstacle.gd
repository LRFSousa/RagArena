extends StaticBody2D

signal destroyed(obstacle: StaticBody2D)

@export var destructible := false
@export var max_hp := 45
@export var size := Vector2(68, 68)
var hp := 45
const CRATE_TEXTURE = preload("res://assets/pixel/crate.png")
const WALL_TEXTURE = preload("res://assets/pixel/wall.png")

func _ready() -> void:
	hp = max_hp
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
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
		draw_texture_rect(CRATE_TEXTURE, rect, false)
		if hp < max_hp:
			var ratio := float(hp) / float(max_hp)
			draw_rect(Rect2(Vector2(-size.x * 0.5, -size.y * 0.5 - 11), Vector2(size.x * ratio, 5)), Color("e8c66b"))
	else:
		draw_texture_rect(WALL_TEXTURE, rect, false)
