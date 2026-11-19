extends Node
class_name CombatSystem

const Projectile = preload("res://scripts/combat_projectile.gd")
const Bot = preload("res://scripts/combat_bot.gd")
const Trap = preload("res://scripts/combat_trap.gd")
const CombatRules = preload("res://scripts/combat_rules.gd")

var settings: ClassBalance
var arena: Node2D
var player: CharacterBody2D
var inventory: PlayerInventory
var progression: MatchProgression
var class_id := "paladin"
var cooldowns := [0.0, 0.0, 0.0]
var invisible := 0.0
var swift := 0.0
var endure := 0.0
var barrier := 0
var barrier_time := 0.0
var bots: Array[CombatBot] = []

func configure(owner_arena: Node2D, actor: CharacterBody2D, bag: PlayerInventory, levels: MatchProgression, data: ClassBalance) -> void:
	arena = owner_arena
	player = actor
	inventory = bag
	progression = levels
	settings = data
	select_class(class_id)
	progression.level_gained.connect(_on_level_gained)

func _on_level_gained(_new_level: int) -> void:
	var old_max := inventory.maximum_hp()
	inventory.max_hp_override = max_hp()
	inventory.hp = mini(inventory.maximum_hp(), inventory.hp + inventory.maximum_hp() - old_max)

func select_class(next_id: String) -> void:
	if not settings.classes.has(next_id):
		return
	class_id = next_id
	inventory.max_hp_override = max_hp()
	cooldowns = [0.0, 0.0, 0.0]
	invisible = 0.0
	swift = 0.0
	endure = 0.0
	barrier = 0
	barrier_time = 0.0
	inventory.hp = max_hp()

func max_hp() -> int:
	return int(settings.stats(class_id, progression.level)["hp"])

func stats() -> Dictionary:
	return settings.stats(class_id, progression.level)

func speed_multiplier() -> float:
	return 1.0 + (settings.assassin_speed_bonus if swift > 0.0 else 0.0)

func spawn_bot(at_position: Vector2) -> CombatBot:
	var bot: CombatBot = Bot.new()
	bot.setup(settings.bot_hp)
	bot.position = at_position
	arena.add_child(bot)
	bots.append(bot)
	return bot

func advance(delta: float) -> void:
	for i in range(3):
		cooldowns[i] = maxf(0.0, cooldowns[i] - delta)
	invisible = maxf(0.0, invisible - delta)
	swift = maxf(0.0, swift - delta)
	endure = maxf(0.0, endure - delta)
	barrier_time = maxf(0.0, barrier_time - delta)
	if barrier_time <= 0.0:
		barrier = 0
	for bot in bots:
		if bot.active and bot.attack_time <= 0.0 and invisible <= 0.0 and bot.position.distance_to(player.position) < 260.0:
			if clear_line(bot.position, player.position, [bot.get_rid(), player.get_rid()]):
				bot.attack_time = settings.bot_attack_interval
				take_player_hit(settings.bot_damage, true)

func clear_line(start: Vector2, finish: Vector2, excludes: Array[RID] = []) -> bool:
	var query := PhysicsRayQueryParameters2D.create(start, finish, 2, excludes)
	return arena.get_world_2d().direct_space_state.intersect_ray(query).is_empty()

func fire_basic() -> bool:
	if invisible > 0.0:
		invisible = 0.0
	var data := stats()
	var aim: Vector2 = player.facing.normalized()
	if class_id == "paladin" or class_id == "assassin":
		return hit_in_line(aim, float(data["range"]), int(data["damage"]), "", false)
	launch(aim, int(data["damage"]), float(data["range"]), "")
	return true

func hit_in_line(aim: Vector2, reach: float, damage: int, effect: String, skill := true) -> bool:
	var start: Vector2 = player.position + aim * 24.0
	var query := PhysicsRayQueryParameters2D.create(start, player.position + aim * reach, 2 | 4, [player.get_rid()])
	var hit := arena.get_world_2d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		return false
	var target: Object = hit["collider"]
	if target is CombatBot:
		hit_bot(target, damage, effect, skill)
		return true
	if target is StaticBody2D and target.has_method("take_crate_damage") and target.destructible and skill:
		hit_crate_from_skill(target, damage)
	return false

func launch(aim: Vector2, damage: int, reach: float, effect: String, piercing := false) -> CombatProjectile:
	var shot: CombatProjectile = Projectile.new()
	shot.position = player.position + aim * 26.0
	shot.direction = aim
	shot.speed = settings.projectile_speed
	shot.range_left = reach
	shot.damage = damage
	shot.effect = effect
	shot.piercing = piercing
	shot.combat = self
	arena.add_child(shot)
	return shot

func hit_bot(bot: CombatBot, raw_damage: int, effect: String = "", skill := false) -> int:
	if not bot.active:
		return 0
	var amount := maxi(0, roundi(raw_damage * inventory.pvp_damage_multiplier()))
	var actual := bot.take_hit(amount)
	if actual > 0:
		progression.grant_effective_pvp_damage_xp(actual, inventory.xp_multiplier())
		if not bot.active:
			progression.grant_elimination_xp(inventory.xp_multiplier())
	if effect == "freeze":
		bot.frozen = settings.mage_freeze_duration
	elif effect == "root":
		bot.rooted = settings.archer_root_duration
	elif effect == "push":
		bot.knockback = (bot.position - player.position).normalized() * 320.0
	return actual

func hit_crate_from_skill(crate: StaticBody2D, _damage: int) -> void:
	# Uma habilidade não supera a regra comum de dano contra caixas.
	crate.take_crate_damage(CombatRules.crate_damage(progression.level))

func take_player_hit(raw_damage: int, ranged: bool, push := false) -> int:
	var amount := maxi(0, raw_damage - int(stats()["defense"]))
	if ranged and class_id == "paladin":
		amount = roundi(amount * (1.0 - settings.paladin_ranged_reduction))
	var absorbed := mini(barrier, amount)
	barrier -= absorbed
	if barrier == 0:
		barrier_time = 0.0
	if push and endure <= 0.0:
		player.position += Vector2(20, 0)
	return inventory.apply_damage(amount - absorbed)

func use_skill(index: int) -> bool:
	if index < 0 or index >= 3 or cooldowns[index] > 0.0 or inventory.hp <= 0:
		return false
	var aim: Vector2 = player.facing.normalized()
	var multiplier := settings.skill_multiplier(progression.level)
	match class_id:
		"paladin":
			match index:
				0: inventory.hp = mini(max_hp(), inventory.hp + roundi(max_hp() * settings.paladin_heal_fraction * multiplier))
				1: endure = settings.paladin_endure_duration * multiplier
				2: hit_in_line(aim, 100.0, roundi(24 * multiplier), "")
		"mage":
			match index:
				0: launch(aim, roundi(8 * multiplier), 330.0, "freeze")
				1:
					barrier = roundi(settings.mage_barrier_capacity * multiplier)
					barrier_time = settings.mage_barrier_duration
				2: launch(aim, roundi(28 * multiplier), 330.0, "fire")
		"assassin":
			match index:
				0: invisible = settings.assassin_invisible_duration
				1: launch(aim, roundi(19 * multiplier), 310.0, "blade")
				2: swift = settings.assassin_speed_duration * multiplier
		"archer":
			match index:
				0:
					for angle in [-0.15, 0.0, 0.15]:
						launch(aim.rotated(angle), roundi(10 * multiplier), 380.0, "arrow")
				1: launch(aim, roundi(12 * multiplier), 350.0, "push")
				2:
					var trap: CombatTrap = Trap.new()
					trap.combat = self
					trap.position = player.position + aim * 65.0
					arena.add_child(trap)
	cooldowns[index] = float(stats()["cooldowns"][index])
	return true
