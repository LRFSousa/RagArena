extends Node2D
class_name CombatProjectile

var direction := Vector2.RIGHT
var speed := 650.0
var range_left := 300.0
var damage := 10
var effect := ""
var combat: Node
var from_player := true
var hit_targets: Array[Node] = []
var piercing := false
var skill_use_id := 0

func _physics_process(delta: float) -> void:
	var travel := minf(range_left, speed * delta)
	if travel <= 0.0:
		queue_free()
		return
	var end := position + direction * travel
	var mask := 2 | (4 if from_player else 1)
	var excludes: Array[RID] = []
	for target in hit_targets:
		if is_instance_valid(target) and target is CollisionObject2D:
			excludes.append(target.get_rid())
	var query := PhysicsRayQueryParameters2D.create(position, end, mask, excludes)
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		position = hit["position"]
		var target: Object = hit["collider"]
		if from_player and target is CombatBot:
			combat.hit_bot(target, damage, effect, skill_use_id > 0, skill_use_id)
			if piercing:
				hit_targets.append(target)
				position += direction * 3.0
				return
		elif not from_player and target == combat.player:
			combat.take_player_hit(damage, true)
		# Caixas e paredes bloqueiam projéteis. Só o ataque comum causa dano em caixas.
		queue_free()
		return
	position = end
	range_left -= travel
	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 8 if from_player else 10, Color("f3d881") if from_player else Color("ff5b52"))
