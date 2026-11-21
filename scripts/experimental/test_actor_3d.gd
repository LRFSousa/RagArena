extends CharacterBody3D
class_name MountainTestActor3D

const WALK := {
	"right": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_right.png"),
	"left": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_left.png"),
	"up": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_up.png"),
	"down": preload("res://assets/characters/swordsman/ragnarena_espachim_walk_down.png"),
}

@export var speed := 4.0
@export var accept_player_input := true
var move_input := Vector2.ZERO
var direction_name := "down"
var sprite: Sprite3D
var walk_time := 0.0

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1
	floor_max_angle = deg_to_rad(42.0)
	floor_snap_length = 0.5
	floor_constant_speed = true
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.35
	capsule.height = 1.8
	var collider := CollisionShape3D.new()
	collider.shape = capsule
	collider.position.y = 0.9
	add_child(collider)
	sprite = Sprite3D.new()
	sprite.texture = WALK[direction_name]
	sprite.hframes = 6
	sprite.pixel_size = 0.009
	sprite.position.y = 0.91
	sprite.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	sprite.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	sprite.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	add_child(sprite)

func _physics_process(delta: float) -> void:
	if accept_player_input:
		move_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector3(move_input.x, 0.0, move_input.y).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity.y -= 9.8 * delta
	move_and_slide()
	if direction.length_squared() > 0.01:
		walk_time += delta
		var next_direction := "right" if absf(direction.x) >= absf(direction.z) and direction.x > 0.0 else "left" if absf(direction.x) >= absf(direction.z) else "down" if direction.z > 0.0 else "up"
		if next_direction != direction_name:
			direction_name = next_direction
			sprite.texture = WALK[direction_name]
		sprite.frame = int(walk_time * 8.0) % 6
	else:
		sprite.frame = 0
