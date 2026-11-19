extends Resource
class_name ClassBalance

# Valores provisórios; cada classe pode ser alterada no Inspector do recurso.
@export var classes: Dictionary = {
	"paladin": {"hp": 140, "damage": 15, "defense": 3, "range": 86.0, "speed": 225.0, "interval": 0.55, "cooldowns": [8.0, 12.0, 10.0]},
	"mage": {"hp": 80, "damage": 12, "defense": 0, "range": 310.0, "speed": 240.0, "interval": 0.8, "cooldowns": [8.0, 12.0, 7.0]},
	"assassin": {"hp": 90, "damage": 11, "defense": 1, "range": 78.0, "speed": 290.0, "interval": 0.3, "cooldowns": [12.0, 6.0, 9.0]},
	"archer": {"hp": 100, "damage": 12, "defense": 1, "range": 360.0, "speed": 255.0, "interval": 0.55, "cooldowns": [7.0, 9.0, 12.0]},
}
@export var level_hp_gain := 2
@export var level_damage_gain := 1
@export var level_skill_milestones: Array[int] = [10, 20, 30]
@export var skill_bonus_per_milestone := 0.1
@export var paladin_ranged_reduction := 0.3
@export var paladin_heal_fraction := 0.25
@export var paladin_endure_duration := 5.0
@export var mage_freeze_duration := 1.5
@export var mage_barrier_capacity := 35
@export var mage_barrier_duration := 6.0
@export var assassin_invisible_duration := 5.0
@export var assassin_speed_duration := 5.0
@export var assassin_speed_bonus := 0.3
@export var archer_root_duration := 2.0
@export var projectile_speed := 650.0
@export var bot_hp := 90
@export var bot_damage := 7
@export var bot_attack_interval := 1.5
@export var bot_projectile_speed := 420.0

func stats(class_id: String, level: int = 1) -> Dictionary:
	var base: Dictionary = classes.get(class_id, classes["paladin"])
	var result := base.duplicate(true)
	result["hp"] = int(base["hp"]) + maxi(0, level - 1) * level_hp_gain
	result["damage"] = int(base["damage"]) + maxi(0, level - 1) * level_damage_gain
	return result

func skill_multiplier(level: int) -> float:
	var count := 0
	for milestone in level_skill_milestones:
		if level >= milestone:
			count += 1
	return 1.0 + count * skill_bonus_per_milestone
