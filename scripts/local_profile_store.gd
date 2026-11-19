extends RefCounted
class_name LocalProfileStore

const CLASS_IDS := ["paladin", "mage", "assassin", "archer"]
const DEFAULT_PATH := "user://profile_v1.json"

var path := DEFAULT_PATH
var data: Dictionary = {}
var last_error := ""

func _init(storage_path: String = DEFAULT_PATH) -> void:
	path = storage_path
	load_profile()

func empty_profile() -> Dictionary:
	return {"version": 1, "account_id": "", "character_name": "", "presets": [], "selected_id": "", "history": []}

func load_profile() -> bool:
	data = empty_profile()
	if not FileAccess.file_exists(path):
		return false
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		last_error = "Não foi possível ler o perfil local."
		return false
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or int(parsed.get("version", 0)) != 1:
		last_error = "Perfil local inválido."
		return false
	for key in data.keys():
		if parsed.has(key):
			data[key] = parsed[key]
	if not data["presets"] is Array or not data["history"] is Array:
		data = empty_profile()
		last_error = "Perfil local inválido."
		return false
	last_error = ""
	return true

func save_profile() -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		last_error = "Não foi possível salvar neste dispositivo."
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.flush()
	last_error = ""
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
