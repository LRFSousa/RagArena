extends RefCounted
class_name ArenaProgression

const CONFIG_PATH := "res://resources/arena_progression.json"

var config: Dictionary = {}
var last_error := ""

func _init(path: String = CONFIG_PATH) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		last_error = "Tabela de progressão indisponível."
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or not valid_config(parsed):
		last_error = "Tabela de progressão inválida."
		return
	config = parsed

static func valid_config(value: Dictionary) -> bool:
	if int(value.get("max_level", 0)) != 40 or not value.get("rewards") is Dictionary:
		return false
	for key in ["base_total_exp", "job_total_exp"]:
		var values = value.get(key)
		if not values is Array or values.size() != 40 or int(values[0]) != 0:
			return false
		for i in range(1, 40):
			if not (values[i] is int or values[i] is float) or int(values[i]) <= int(values[i - 1]):
				return false
	return int(value["base_total_exp"][9]) == 900 and int(value["base_total_exp"][19]) == 5200 and int(value["base_total_exp"][29]) == 13000 and int(value["base_total_exp"][39]) == 30000 and int(value["job_total_exp"][9]) == 500 and int(value["job_total_exp"][19]) == 3300 and int(value["job_total_exp"][29]) == 8500 and int(value["job_total_exp"][39]) == 16500

func level_for(total_exp: int, track: String) -> int:
	var values: Array = config["base_total_exp" if track == "base" else "job_total_exp"]
	var level := 1
	for i in range(1, values.size()):
		if total_exp < int(values[i]):
			break
		level = i + 1
	return level

func capped_total(total_exp: int, track: String) -> int:
	var values: Array = config["base_total_exp" if track == "base" else "job_total_exp"]
	return clampi(total_exp, 0, int(values[39]))

func reward(report: Dictionary) -> Dictionary:
	var rules: Dictionary = config["rewards"]
	var seconds := clampf(float(report.get("active_seconds", 0.0)), 0.0, clampf(float(report.get("arena_limit_seconds", 480.0)), 1.0, 3600.0))
	var minutes := maxi(0, int(floorf(seconds / 60.0)))
	var kills := clampi(int(report.get("kills", 0)), 0, int(rules["max_kills"]))
	var assists := clampi(int(report.get("assists", 0)), 0, int(rules["max_assists"]))
	var skills := clampi(int(report.get("effective_skills", 0)), 0, int(rules["max_skills"]))
	var completed := bool(report.get("completed_with_winner", false)) and not bool(report.get("dead", false)) and not bool(report.get("abandoned", false))
	var won := completed and bool(report.get("won", false))
	var base := minutes * int(rules["base_per_full_minute"]) + kills * int(rules["kill_base"]) + assists * int(rules["assist_base"])
	var job := minutes * int(rules["job_per_full_minute"]) + kills * int(rules["kill_job"]) + assists * int(rules["assist_job"]) + skills * int(rules["skill_job"])
	if completed:
		base += int(rules["completion_base"])
		job += int(rules["completion_job"])
	if won:
		base += int(rules["victory_base"])
		job += int(rules["victory_job"])
	var percent := int(rules["death_multiplier_percent"]) if bool(report.get("dead", false)) else 100
	return {"base": floori(float(base * percent) / 100.0), "job": floori(float(job * percent) / 100.0), "gross_base": base, "gross_job": job, "minutes": minutes, "kills": kills, "assists": assists, "effective_skills": skills, "completed": completed, "won": won}
