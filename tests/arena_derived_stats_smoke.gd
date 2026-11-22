extends SceneTree

const Derived = preload("res://scripts/arena_derived_stats.gd")
const Attributes = preload("res://scripts/arena_attributes.gd")

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
	var hp_points := {"swordsman": [1000, 3000, 6000], "thief": [900, 2600, 5000], "archer": [850, 2400, 4600], "acolyte": [900, 2500, 4800], "mage": [800, 2100, 4000]}
	for class_id in hp_points:
		for index in 3:
			assert(Derived.base_hp(class_id, [1, 20, 40][index]) == hp_points[class_id][index], "Curva de HP: %s" % class_id)
	character["class_id"] = "swordsman"
	character["job_level"] = 1
	for base_level in [1, 20, 40]:
		character["base_level"] = base_level
		var duel := Derived.calculate(character)
		assert(duel["basic_damage"] > duel["atk"], "HP e dano usam escala de arena")
		var time_to_defeat := ceilf(float(duel["hp"]) / float(duel["basic_damage"])) * 0.75
		assert(time_to_defeat >= 15.0 and time_to_defeat <= 25.0, "Duelo de referencia dura 15 a 25 segundos no Base %d" % base_level)
	var expected := {
		"swordsman": [4, 1, 3, 0, 3, 1],
		"mage": [0, 3, 0, 5, 3, 1],
		"archer": [3, 2, 0, 1, 5, 1],
		"acolyte": [1, 2, 2, 2, 2, 3],
		"thief": [3, 3, 1, 1, 2, 2]
	}
	for class_id in expected:
		character["class_id"] = class_id
		character["job_level"] = 1
		for key in Attributes.KEYS:
			assert(Attributes.bonus_value(character, key) == 0, "Job 1 sem bonus: %s" % class_id)
		character["job_level"] = 40
		for index in Attributes.KEYS.size():
			assert(Attributes.bonus_value(character, Attributes.KEYS[index]) == expected[class_id][index], "Bonus Job 40: %s/%s" % [class_id, Attributes.KEYS[index]])
	character["class_id"] = "swordsman"
	character["job_level"] = 2
	assert(Attributes.bonus_value(character, "for") == 1, "FOR no Job 2")
	assert(Derived.calculate(character)["atk"] > Derived.calculate({"base_level": 1, "class_id": "swordsman", "job_level": 1, "attributes": character["attributes"]})["atk"], "Bonus Job altera ATK")
	character["job_level"] = 6
	assert(Attributes.bonus_value(character, "vit") == 1, "VIT no Job 6")
	assert(Attributes.bonus_value(character, "invalid") == 0, "Chave invalida sem bonus")
	print("arena_derived_stats_smoke: OK")
	quit()
