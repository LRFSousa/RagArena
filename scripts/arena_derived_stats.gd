extends RefCounted
class_name ArenaDerivedStats

const Attributes = preload("res://scripts/arena_attributes.gd")

# Escala própria da arena. Os componentes seguem os papéis dos atributos
# Pre-Renewal; não representam os números finais do servidor Ragnarok.
static func calculate(character: Dictionary) -> Dictionary:
	var s := Attributes.effective_value(character, "for")
	var a := Attributes.effective_value(character, "agi")
	var v := Attributes.effective_value(character, "vit")
	var i := Attributes.effective_value(character, "int")
	var d := Attributes.effective_value(character, "des")
	var l := Attributes.effective_value(character, "sor")
	var level := maxi(1, int(character.get("base_level", 1)))
	var atk := 14 + s + (s / 10) * (s / 10) + d / 5 + l / 5
	return {
		"hp": 90 + level * 2 + v * 2,
		"sp": 30 + level + i * 2,
		"hp_regen": 1 + v / 5,
		"sp_regen": 1 + i / 6,
		"atk": atk,
		"matk": 5 + i + (i / 5) * (i / 5),
		"def": v,
		"mdef": i + v / 2,
		"hit": 80 + level + d + l / 3,
		"flee": 80 + level + a + l / 5,
		"move_speed": 8.0,
		"attack_speed": minf(150.0, 100.0 + a * 0.4 + d * 0.1),
		"range": 2
	}
