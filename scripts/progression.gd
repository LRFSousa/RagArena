extends Node
class_name MatchProgression

signal changed
signal level_gained(new_level: int)

var balance: GameBalance
var level := 1
var xp := 0
var total_xp := 0

func configure(settings: GameBalance) -> void:
	balance = settings
	level = 1
	xp = 0
	total_xp = 0
	changed.emit()

func xp_to_next() -> int:
	if level >= balance.max_level:
		return 0
	return maxi(1, roundi(balance.xp_first_level * pow(balance.xp_growth, level - 1)))

func grant_xp(base_amount: int, multiplier: float = 1.0) -> int:
	if base_amount <= 0 or level >= balance.max_level:
		return 0
	var gained := maxi(0, roundi(base_amount * maxf(0.0, multiplier)))
	xp += gained
	total_xp += gained
	while level < balance.max_level and xp >= xp_to_next():
		xp -= xp_to_next()
		level += 1
		level_gained.emit(level)
	if level >= balance.max_level:
		xp = 0
	changed.emit()
	return gained

# Estas fontes ficam disponíveis para a release 0.3; não há inimigos nesta release.
func grant_effective_pvp_damage_xp(effective_damage: float, multiplier: float = 1.0) -> int:
	return grant_xp(roundi(maxf(0.0, effective_damage) * balance.xp_per_pvp_damage), multiplier)

func grant_elimination_xp(multiplier: float = 1.0) -> int:
	return grant_xp(balance.xp_per_elimination, multiplier)
