extends Resource
class_name GameBalance

@export_range(1, 30, 1) var max_level := 30
@export_range(1, 10000, 1) var xp_first_level := 20
@export_range(1.0, 3.0, 0.01) var xp_growth := 1.22
@export_range(0, 10000, 1) var xp_per_crate := 20
@export_range(0.0, 10.0, 0.1) var xp_per_pvp_damage := 1.0
@export_range(0, 10000, 1) var xp_per_elimination := 60

@export_range(0.0, 1.0, 0.01) var drop_chance := 0.30
@export var drop_weights: Dictionary = {
	"health_potion": 30,
	"strength": 15,
	"speed": 15,
	"shield": 15,
	"elixir": 10,
	"xp_amulet": 15,
}
@export_range(0.1, 120.0, 0.1) var ground_item_lifetime := 20.0
@export_range(1.0, 100.0, 1.0) var pickup_radius := 38.0
@export_range(0.0, 10.0, 0.1) var manual_use_cooldown := 2.0
@export_range(1, 8, 1) var inventory_slots := 4
@export_range(1, 10, 1) var potion_stack_limit := 3

@export_range(1, 1000, 1) var max_hp := 100
@export_range(1.0, 1000.0, 1.0) var base_move_speed := 260.0
@export_range(0.0, 1.0, 0.01) var health_potion_fraction := 0.30
@export_range(0.0, 1.0, 0.01) var elixir_fraction := 0.60
@export_range(0.0, 2.0, 0.01) var strength_bonus := 0.20
@export_range(0.0, 2.0, 0.01) var speed_bonus := 0.15
@export_range(0.0, 2.0, 0.01) var xp_amulet_bonus := 0.25
@export_range(0.1, 120.0, 0.1) var strength_duration := 15.0
@export_range(0.1, 120.0, 0.1) var speed_duration := 12.0
@export_range(0.1, 120.0, 0.1) var shield_duration := 15.0
@export_range(1, 1000, 1) var shield_capacity := 30
@export_range(0.1, 120.0, 0.1) var xp_amulet_duration := 15.0
