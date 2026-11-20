extends Node2D
class_name CombatTrap

var combat: CombatSystem
var lifetime := 8.0
var radius := 26.0
var skill_use_id := 0

func _physics_process(delta: float) -> void:
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()
		return
	for bot in combat.bots:
		if bot.active and bot.position.distance_to(position) <= radius:
			combat.hit_bot(bot, 5, "root", true, skill_use_id)
			queue_free()
			return
	queue_redraw()

func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, 0, TAU, 20, Color("d9a85a"), 3)
