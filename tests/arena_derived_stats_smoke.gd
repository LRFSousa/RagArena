extends SceneTree

const Derived = preload("res://scripts/arena_derived_stats.gd")

func _initialize() -> void:
	var character := {"base_level": 1, "attributes": {"for": 5, "agi": 5, "vit": 5, "int": 5, "des": 5, "sor": 5}}
	var initial := Derived.calculate(character)
	character["attributes"]["for"] = 6
	assert(Derived.calculate(character)["atk"] > initial["atk"], "FOR deve aumentar ATK")
	character["attributes"]["vit"] = 6
	assert(Derived.calculate(character)["hp"] > initial["hp"], "VIT deve aumentar HP")
	assert(Derived.calculate(character)["def"] > initial["def"], "VIT deve aumentar DEF")
	character["attributes"]["int"] = 6
	assert(Derived.calculate(character)["sp"] > initial["sp"], "INT deve aumentar SP")
	character["attributes"]["des"] = 6
	assert(Derived.calculate(character)["hit"] > initial["hit"], "DES deve aumentar acerto")
	character["attributes"]["agi"] = 6
	assert(Derived.calculate(character)["flee"] > initial["flee"], "AGI deve aumentar esquiva")
	assert(Derived.calculate(character)["move_speed"] == initial["move_speed"], "AGI não altera deslocamento")
	assert(Derived.calculate(character)["range"] == 2, "Alcance físico deve permanecer em 2 blocos")
	print("arena_derived_stats_smoke: OK")
	quit()
