extends Node
class_name PlayerInventory

signal changed

const ITEM_IDS := ["health_potion", "strength", "speed", "shield", "elixir", "xp_amulet"]
const POTION_IDS := ["health_potion", "elixir"]

var balance: GameBalance
var slots: Array[Dictionary] = []
var active: Dictionary = {}
var hp := 100
var max_hp_override := 0
var shield_points := 0
var use_cooldown := 0.0

func configure(settings: GameBalance) -> void:
	balance = settings
	slots.clear()
	for i in range(balance.inventory_slots):
		slots.append({"id": "", "quantity": 0})
	active.clear()
	hp = balance.max_hp
	max_hp_override = 0
	shield_points = 0
	use_cooldown = 0.0
	changed.emit()

func pickup_item(item_id: String) -> bool:
	if not ITEM_IDS.has(item_id):
		return false
	if item_id == "xp_amulet":
		active[item_id] = balance.xp_amulet_duration
		changed.emit()
		return true
	if POTION_IDS.has(item_id):
		for i in range(slots.size()):
			var slot: Dictionary = slots[i]
			if slot["id"] == item_id and slot["quantity"] < balance.potion_stack_limit:
				slot["quantity"] += 1
				slots[i] = slot
				changed.emit()
				return true
	for i in range(slots.size()):
		if slots[i]["id"] == "":
			slots[i] = {"id": item_id, "quantity": 1}
			changed.emit()
			return true
	return false

func use_slot(index: int) -> bool:
	if index < 0 or index >= slots.size() or use_cooldown > 0.0:
		return false
	var slot: Dictionary = slots[index]
	var item_id: String = slot["id"]
	if item_id == "":
		return false
	match item_id:
		"health_potion":
			if hp >= maximum_hp():
				return false
			hp = mini(maximum_hp(), hp + roundi(maximum_hp() * balance.health_potion_fraction))
		"elixir":
			if hp >= maximum_hp():
				return false
			hp = mini(maximum_hp(), hp + roundi(maximum_hp() * balance.elixir_fraction))
		"strength":
			active[item_id] = balance.strength_duration
		"speed":
			active[item_id] = balance.speed_duration
		"shield":
			active[item_id] = balance.shield_duration
			shield_points = balance.shield_capacity
		_:
			return false
	slot["quantity"] -= 1
	if slot["quantity"] <= 0:
		slot = {"id": "", "quantity": 0}
	slots[index] = slot
	use_cooldown = balance.manual_use_cooldown
	changed.emit()
	return true

func advance(delta: float) -> void:
	if delta <= 0.0:
		return
	use_cooldown = maxf(0.0, use_cooldown - delta)
	for item_id in active.keys():
		var remaining: float = maxf(0.0, active[item_id] - delta)
		if remaining <= 0.0:
			active.erase(item_id)
			if item_id == "shield":
				shield_points = 0
		else:
			active[item_id] = remaining

func effect_remaining(item_id: String) -> float:
	return float(active.get(item_id, 0.0))

func maximum_hp() -> int:
	return max_hp_override if max_hp_override > 0 else balance.max_hp

func pvp_damage_multiplier() -> float:
	return 1.0 + (balance.strength_bonus if active.has("strength") else 0.0)

func movement_speed_multiplier() -> float:
	return 1.0 + (balance.speed_bonus if active.has("speed") else 0.0)

func xp_multiplier() -> float:
	return 1.0 + (balance.xp_amulet_bonus if active.has("xp_amulet") else 0.0)

func apply_damage(amount: int) -> int:
	if amount <= 0:
		return 0
	var remaining := amount
	if active.has("shield") and shield_points > 0:
		var absorbed := mini(shield_points, remaining)
		shield_points -= absorbed
		remaining -= absorbed
		if shield_points == 0:
			active.erase("shield")
	var prior_hp := hp
	hp = maxi(0, hp - remaining)
	changed.emit()
	return prior_hp - hp
