extends RefCounted
class_name LocalProfileStore

const CLASS_IDS := ["paladin", "mage", "assassin", "archer"]
const CHARACTER_CLASS_IDS := ["swordsman", "mage", "archer", "acolyte", "thief"]
const MAX_CHARACTERS := 9
const DEFAULT_PATH := "user://profile_v1.json"
const ProgressionScript = preload("res://scripts/arena_progression.gd")
const AttributesScript = preload("res://scripts/arena_attributes.gd")
const SkillTree = preload("res://scripts/swordsman_skill_tree.gd")
const ItemCatalog = preload("res://scripts/arena_item_catalog.gd")

var path := DEFAULT_PATH
var data: Dictionary = {}
var last_error := ""

func _init(storage_path: String = DEFAULT_PATH) -> void:
	path = storage_path
	load_profile()

func empty_profile() -> Dictionary:
	return {"version": 3, "account_id": "", "character_name": "", "presets": [], "selected_id": "", "history": [], "characters": [], "selected_character_id": "", "processed_matches": []}

func load_profile() -> bool:
	data = empty_profile()
	if not FileAccess.file_exists(path):
		return false
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		last_error = "Não foi possível ler o perfil local."
		return false
	var parser := JSON.new()
	var parsed = parser.data if parser.parse(file.get_as_text()) == OK else null
	if (not parsed is Dictionary or not [1, 2, 3].has(int(parsed.get("version", 0)))) and FileAccess.file_exists(path + ".bak"):
		var backup_file := FileAccess.open(path + ".bak", FileAccess.READ)
		if backup_file != null:
			var backup_parser := JSON.new()
			parsed = backup_parser.data if backup_parser.parse(backup_file.get_as_text()) == OK else null
	if not parsed is Dictionary or not [1, 2, 3].has(int(parsed.get("version", 0))):
		last_error = "Perfil local inválido."
		return false
	var was_legacy := int(parsed["version"]) == 1
	for key in data.keys():
		if parsed.has(key) and key != "version":
			data[key] = parsed[key]
	if not data["presets"] is Array or not data["history"] is Array or not data["characters"] is Array or not data["processed_matches"] is Array:
		data = empty_profile()
		last_error = "Perfil local inválido."
		return false
	var needs_upgrade := int(parsed["version"]) != 3
	var attribute_rules := AttributesScript.new()
	if attribute_rules.config.is_empty():
		last_error = attribute_rules.last_error
		return false
	for character in data["characters"]:
		if not character is Dictionary:
			last_error = "Personagem inválido no perfil."
			return false
		if not character.has("attributes"):
			character["attributes"] = AttributesScript.initial_values()
			character["attribute_points"] = attribute_rules.total_at(int(character.get("base_level", 1))) - 48
			character["attribute_awarded_through_level"] = int(character.get("base_level", 1))
			needs_upgrade = true
		if not character.has("skill_points"):
			character["skill_points"] = maxi(0, int(character.get("job_level", 1)) - 1)
			character["skill_awarded_through_level"] = int(character.get("job_level", 1))
			needs_upgrade = true
		if not character.has("skill_ranks"):
			character["skill_ranks"] = {}
			needs_upgrade = true
		if not character.has("inventory") or not character["inventory"] is Dictionary:
			character["inventory"] = {}
			needs_upgrade = true
		if not character.has("equipment") or not character["equipment"] is Dictionary:
			character["equipment"] = {}
			needs_upgrade = true
	if was_legacy and str(data["account_id"]) != "":
		var old_class := "swordsman"
		var legacy_preset := find_preset(str(data["selected_id"]))
		if legacy_preset.is_empty() and not data["presets"].is_empty():
			legacy_preset = data["presets"][0]
		match str(legacy_preset.get("class_id", "paladin")):
			"mage": old_class = "mage"
			"archer": old_class = "archer"
			"assassin": old_class = "thief"
		var id := Crypto.new().generate_random_bytes(16).hex_encode()
		data["characters"].append(new_character(id, str(data["character_name"]), old_class))
		data["selected_character_id"] = id
		var backup := FileAccess.open(path + ".v1.bak", FileAccess.WRITE)
		if backup != null:
			backup.store_string(JSON.stringify(parsed, "\t"))
			backup.flush()
		needs_upgrade = true
	data["version"] = 3
	if needs_upgrade and not save_profile():
		return false
	last_error = ""
	return true

func save_profile() -> bool:
	if FileAccess.file_exists(path):
		var source := FileAccess.open(path, FileAccess.READ)
		if source != null:
			var backup := FileAccess.open(path + ".bak", FileAccess.WRITE)
			if backup != null:
				backup.store_string(source.get_as_text())
				backup.flush()
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		last_error = "Não foi possível salvar neste dispositivo."
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.flush()
	last_error = ""
	return true

static func new_character(id: String, character_name: String, class_id: String) -> Dictionary:
	return {"id": id, "name": character_name, "class_id": class_id, "base_level": 1, "base_exp": 0, "job_level": 1, "job_exp": 0, "attributes": AttributesScript.initial_values(), "attribute_points": 0, "skill_points": 0, "skill_ranks": {}, "inventory": {}, "equipment": {}, "attribute_awarded_through_level": 1, "skill_awarded_through_level": 1}

func grant_item(character_id: String, item_id: String, quantity: int = 1) -> bool:
	var character := find_character(character_id)
	var definition: Dictionary = ItemCatalog.item(item_id)
	if character.is_empty() or definition.is_empty() or quantity < 1:
		last_error = "Item ou personagem inválido."
		return false
	var inventory: Dictionary = character["inventory"]
	var old_count := int(inventory.get(item_id, 0))
	if old_count + quantity > int(definition["max_stack"]):
		last_error = "Limite de itens atingido."
		return false
	inventory[item_id] = old_count + quantity
	if not save_profile():
		if old_count == 0: inventory.erase(item_id)
		else: inventory[item_id] = old_count
		return false
	return true

func equip_item(character_id: String, item_id: String) -> bool:
	var character := find_character(character_id)
	var definition: Dictionary = ItemCatalog.item(item_id)
	if character.is_empty() or not definition.has("slot") or int(character["inventory"].get(item_id, 0)) < 1:
		last_error = "Equipamento indisponível."
		return false
	var slot: String = definition["slot"]
	var old_id := str(character["equipment"].get(slot, ""))
	character["inventory"].erase(item_id)
	if old_id != "": character["inventory"][old_id] = 1
	character["equipment"][slot] = item_id
	if not save_profile():
		character["equipment"][slot] = old_id
		character["inventory"][item_id] = 1
		if old_id != "": character["inventory"].erase(old_id)
		return false
	return true

func use_item(character_id: String, item_id: String) -> bool:
	var character := find_character(character_id)
	var definition: Dictionary = ItemCatalog.item(item_id)
	if character.is_empty() or not definition.has("heal_percent"):
		return false
	var inventory: Dictionary = character["inventory"]
	var old_count := int(inventory.get(item_id, 0))
	if old_count < 1: return false
	if old_count == 1: inventory.erase(item_id)
	else: inventory[item_id] = old_count - 1
	if not save_profile():
		inventory[item_id] = old_count
		return false
	return true

func create_character(character_name: String, class_id: String) -> String:
	if not has_identity() or not valid_character_name(character_name) or not CHARACTER_CLASS_IDS.has(class_id) or data["characters"].size() >= MAX_CHARACTERS:
		last_error = "Nome, classe ou limite de personagens inválido."
		return ""
	for existing in data["characters"]:
		if str(existing.get("name", "")).to_lower() == character_name.to_lower():
			last_error = "Este nome já está em uso nesta conta."
			return ""
	var id := Crypto.new().generate_random_bytes(16).hex_encode()
	data["characters"].append(new_character(id, character_name, class_id))
	if str(data["selected_character_id"]) == "":
		data["selected_character_id"] = id
	if not save_profile():
		data["characters"].pop_back()
		return ""
	return id

func find_character(id: String) -> Dictionary:
	for character in data["characters"]:
		if character is Dictionary and str(character.get("id", "")) == id:
			return character
	return {}

func select_character(id: String) -> bool:
	if find_character(id).is_empty():
		last_error = "Personagem não encontrado."
		return false
	data["selected_character_id"] = id
	return save_profile()

func settle_match(character_id: String, report: Dictionary) -> Dictionary:
	var match_id := str(report.get("match_id", ""))
	var character := find_character(character_id)
	if character.is_empty() or match_id == "":
		last_error = "Personagem ou participação inválida."
		return {}
	var key := character_id + ":" + match_id
	if data["processed_matches"].has(key):
		last_error = "Participação já processada."
		return {}
	var progression := ProgressionScript.new()
	var attribute_rules := AttributesScript.new()
	if progression.config.is_empty():
		last_error = progression.last_error
		return {}
	if attribute_rules.config.is_empty():
		last_error = attribute_rules.last_error
		return {}
	var reward: Dictionary = progression.reward(report)
	var before := character.duplicate(true)
	var old_base := int(character["base_level"])
	var old_job := int(character["job_level"])
	var old_base_exp := int(character["base_exp"])
	var old_job_exp := int(character["job_exp"])
	character["base_exp"] = progression.capped_total(old_base_exp + int(reward["base"]), "base")
	character["job_exp"] = progression.capped_total(old_job_exp + int(reward["job"]), "job")
	character["base_level"] = progression.level_for(int(character["base_exp"]), "base")
	character["job_level"] = progression.level_for(int(character["job_exp"]), "job")
	var base_from := int(character.get("attribute_awarded_through_level", old_base))
	var job_from := int(character.get("skill_awarded_through_level", old_job))
	var attribute_gain := attribute_rules.points_between(base_from, int(character["base_level"]))
	var skill_gain := maxi(0, int(character["job_level"]) - job_from)
	character["attribute_points"] = int(character.get("attribute_points", 0)) + attribute_gain
	character["skill_points"] = int(character.get("skill_points", 0)) + skill_gain
	character["attribute_awarded_through_level"] = maxi(base_from, int(character["base_level"]))
	character["skill_awarded_through_level"] = maxi(job_from, int(character["job_level"]))
	data["processed_matches"].append(key)
	data["history"].append({"character_id": character_id, "match_id": match_id, "winner": str(report.get("winner", "")), "reason": str(report.get("reason", "")), "base_reward": int(reward["base"]), "job_reward": int(reward["job"]), "played_at": Time.get_datetime_string_from_system(true)})
	if not save_profile():
		character.clear()
		character.merge(before)
		data["processed_matches"].pop_back()
		data["history"].pop_back()
		return {}
	reward["base_awarded"] = int(character["base_exp"]) - old_base_exp
	reward["job_awarded"] = int(character["job_exp"]) - old_job_exp
	reward["base_levels"] = int(character["base_level"]) - old_base
	reward["job_levels"] = int(character["job_level"]) - old_job
	reward["attribute_points_awarded"] = attribute_gain
	reward["skill_points_awarded"] = skill_gain
	return reward

func spend_attribute_point(character_id: String, key: String) -> bool:
	var character := find_character(character_id)
	if character.is_empty() or not AttributesScript.KEYS.has(key):
		last_error = "Personagem ou atributo inválido."
		return false
	var base := AttributesScript.base_value(character, key)
	var cost := AttributesScript.next_cost(base)
	if base >= 99 or int(character.get("attribute_points", 0)) < cost:
		last_error = "Pontos insuficientes ou atributo no limite."
		return false
	var before := character.duplicate(true)
	character["attributes"][key] = base + 1
	character["attribute_points"] = int(character["attribute_points"]) - cost
	if not save_profile():
		character.clear()
		character.merge(before)
		return false
	return true

func spend_skill_point(character_id: String, skill_id: String) -> bool:
	var character := find_character(character_id)
	if character.is_empty() or not SkillTree.can_spend(character, skill_id):
		last_error = "Ponto insuficiente, classe incompatível, rank máximo ou pré-requisito pendente."
		return false
	var before := character.duplicate(true)
	character["skill_ranks"][skill_id] = SkillTree.rank(character, skill_id) + 1
	character["skill_points"] = int(character["skill_points"]) - 1
	if not save_profile():
		character.clear()
		character.merge(before)
		return false
	return true

static func valid_character_name(value: String) -> bool:
	if value.length() < 3 or value.length() > 16:
		return false
	for i in range(value.length()):
		var code := value.unicode_at(i)
		if not ((code >= 48 and code <= 57) or (code >= 65 and code <= 90) or (code >= 97 and code <= 122) or code == 95):
			return false
	return true

static func valid_preset_name(value: String) -> bool:
	return value.strip_edges() == value and value.length() >= 1 and value.length() <= 24

func has_identity() -> bool:
	return str(data["account_id"]) != "" and valid_character_name(str(data["character_name"]))

func create_identity(character_name: String) -> bool:
	if has_identity():
		last_error = "Já existe um personagem neste perfil local."
		return false
	if not valid_character_name(character_name):
		last_error = "Use 3–16 letras, números ou _."
		return false
	data = empty_profile()
	data["account_id"] = Crypto.new().generate_random_bytes(16).hex_encode()
	data["character_name"] = character_name
	return save_profile()

func create_preset(preset_name: String, class_id: String) -> String:
	if not has_identity() or not valid_preset_name(preset_name) or not CLASS_IDS.has(class_id):
		last_error = "Nome ou classe inválida."
		return ""
	var id := Crypto.new().generate_random_bytes(16).hex_encode()
	data["presets"].append({"id": id, "name": preset_name, "class_id": class_id})
	if data["selected_id"] == "":
		data["selected_id"] = id
	if not save_profile():
		return ""
	return id

func find_preset(id: String) -> Dictionary:
	for preset in data["presets"]:
		if preset is Dictionary and str(preset.get("id", "")) == id:
			return preset
	return {}

func edit_preset(id: String, preset_name: String, class_id: String) -> bool:
	if not valid_preset_name(preset_name) or not CLASS_IDS.has(class_id):
		last_error = "Nome ou classe inválida."
		return false
	for i in range(data["presets"].size()):
		if str(data["presets"][i].get("id", "")) == id:
			data["presets"][i] = {"id": id, "name": preset_name, "class_id": class_id}
			return save_profile()
		last_error = "Configuração não encontrada."
	return false

func delete_preset(id: String) -> bool:
	for i in range(data["presets"].size()):
		if str(data["presets"][i].get("id", "")) == id:
			data["presets"].remove_at(i)
			if data["selected_id"] == id:
				data["selected_id"] = "" if data["presets"].is_empty() else str(data["presets"][0]["id"])
			return save_profile()
	last_error = "Configuração não encontrada."
	return false

func select_preset(id: String) -> bool:
	if find_preset(id).is_empty():
		last_error = "Configuração não encontrada."
		return false
	data["selected_id"] = id
	return save_profile()

func record_result(result: Dictionary, preset_id: String) -> bool:
	if not has_identity() or find_preset(preset_id).is_empty():
		return false
	var entry := {"preset_id": preset_id, "winner": str(result.get("winner", "")), "reason": str(result.get("reason", "")), "level": int(result.get("level", 1)), "xp": int(result.get("xp", 0)), "crates": int(result.get("crates", 0)), "elapsed": float(result.get("elapsed", 0.0)), "played_at": Time.get_datetime_string_from_system(true)}
	data["history"].append(entry)
	while data["history"].size() > 50:
		data["history"].pop_front()
	return save_profile()
