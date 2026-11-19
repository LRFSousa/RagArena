extends RefCounted

const CRATE_HP := 45

static func crate_damage(level: int) -> int:
	var safe_level := clampi(level, 1, 30)
	if safe_level <= 3:
		return 15
	if safe_level <= 7:
		return 23
	return 45

# Dano PvP pertence à release 0.3 e não é chamado pelo ataque a caixas.
