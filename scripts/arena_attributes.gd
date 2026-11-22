extends RefCounted
class_name ArenaAttributes

const CONFIG_PATH := "res://resources/attribute_points_v1.json"
const KEYS := ["for", "agi", "vit", "int", "des", "sor"]
const LABELS := {"for": "FOR", "agi": "AGI", "vit": "VIT", "int": "INT", "des": "DES", "sor": "SOR"}

var config: Dictionary = {}
var last_error := ""

func _init(config_path: String = CONFIG_PATH) -> void:
	var file := FileAccess.open(config_path, FileAccess.READ)
	if file == null:
		last_error = "Tabela de pontos indisponível."
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or not valid_config(parsed):
		last_error = "Tabela de pontos inválida."
		return
	config = parsed

static func valid_config(value: Dictionary) -> bool:
	var totals = value.get("total_points")
	if int(value.get("max_level", 0)) != 40 or not totals is Array or totals.size() != 40:
		return false
	if int(value.get("initial_points_spent", -1)) != 48 or int(value.get("initial_base", -1)) != 5:
		return false
	for i in range(40):
		if not (totals[i] is int or totals[i] is float):
			return false
		if i > 0 and int(totals[i]) <= int(totals[i - 1]):
			return false
	return int(totals[0]) == 48 and int(totals[9]) == 80 and int(totals[19]) == 135 and int(totals[29]) == 210 and int(totals[39]) == 305

func total_at(level: int) -> int:
	return int(config["total_points"][clampi(level, 1, 40) - 1])

func points_between(old_level: int, new_level: int) -> int:
	return maxi(0, total_at(new_level) - total_at(old_level))

static func initial_values() -> Dictionary:
	return {"for": 5, "agi": 5, "vit": 5, "int": 5, "des": 5, "sor": 5}

static func next_cost(current_base: int) -> int:
	return 1 + floori(float(current_base + 9) / 10.0)

static func base_value(character: Dictionary, key: String) -> int:
	return int(character.get("attributes", {}).get(key, 5))

static func bonus_value(_character: Dictionary, _key: String) -> int:
	# Equipamentos, buffs e bônus por classe entram aqui em uma etapa futura.
	return 0

static func effective_value(character: Dictionary, key: String) -> int:
	return base_value(character, key) + bonus_value(character, key)
