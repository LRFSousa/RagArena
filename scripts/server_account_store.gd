extends RefCounted
class_name ServerAccountStore

const DEFAULT_PATH := "user://server_accounts_v1.json"
const KDF_ITERATIONS := 100000
const SESSION_SECONDS := 86400.0
const CLASS_IDS := ["paladin", "mage", "assassin", "archer"]

var path := DEFAULT_PATH
var users: Array[Dictionary] = []
var sessions: Dictionary = {}
var crypto := Crypto.new()
var last_error := ""

func _init(storage_path: String = DEFAULT_PATH) -> void:
	path = storage_path
	load_accounts()

func load_accounts() -> bool:
	users.clear()
	if not FileAccess.file_exists(path):
		return true
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		last_error = "Não foi possível ler as contas do servidor."
		return false
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary or int(parsed.get("version", 0)) != 1 or not parsed.get("users") is Array:
		last_error = "Arquivo de contas inválido; servidor não deve sobrescrevê-lo."
		return false
	for entry in parsed["users"]:
		if not entry is Dictionary or not entry.has("id") or not entry.has("email") or not entry.has("name") or not entry.has("salt") or not entry.has("hash"):
			last_error = "Arquivo de contas inválido; servidor não deve sobrescrevê-lo."
			users.clear()
			return false
		users.append(entry)
	last_error = ""
	return true

func save_accounts() -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		last_error = "Não foi possível salvar as contas."
		return false
	file.store_string(JSON.stringify({"version": 1, "users": users}, "\t"))
	file.flush()
	return true

static func normalized_email(value: String) -> String:
	return value.strip_edges().to_lower()

static func valid_email(value: String) -> bool:
	if value.length() < 5 or value.length() > 254 or value.contains(" ") or value.contains("\n"):
		return false
	var parts := value.split("@")
	return parts.size() == 2 and parts[0] != "" and parts[1].contains(".") and not parts[1].begins_with(".") and not parts[1].ends_with(".")

static func valid_password(value: String) -> bool:
	return value.length() >= 12 and value.length() <= 128

func derive_key(password: String, salt_hex: String) -> PackedByteArray:
	var salt: PackedByteArray = salt_hex.hex_decode()
	var key := password.to_utf8_buffer()
	var block := salt.duplicate()
	block.append_array(PackedByteArray([0, 0, 0, 1]))
	var previous: PackedByteArray = crypto.hmac_digest(HashingContext.HASH_SHA256, key, block)
	var output := previous.duplicate()
	for i in range(1, KDF_ITERATIONS):
		previous = crypto.hmac_digest(HashingContext.HASH_SHA256, key, previous)
		for j in range(output.size()):
			output[j] = output[j] ^ previous[j]
	return output

func find_email(email: String) -> Dictionary:
	var needle := normalized_email(email)
	for user in users:
		if user["email"] == needle:
			return user
	return {}

func find_name(name: String) -> Dictionary:
	var needle := name.to_lower()
	for user in users:
		if str(user["name"]).to_lower() == needle:
			return user
	return {}

func find_id(id: String) -> Dictionary:
	for user in users:
		if user["id"] == id:
			return user
	return {}

func register(email: String, password: String, character_name: String) -> Dictionary:
	var normalized := normalized_email(email)
	if not valid_email(normalized) or not valid_password(password) or not LocalProfileStore.valid_character_name(character_name):
		return {"ok": false, "error": "Email, senha ou nome inválido."}
	if not find_email(normalized).is_empty():
		return {"ok": false, "error": "Email já cadastrado."}
	if not find_name(character_name).is_empty():
		return {"ok": false, "error": "Nome já cadastrado."}
	var salt := crypto.generate_random_bytes(16).hex_encode()
	var user := {"id": crypto.generate_random_bytes(16).hex_encode(), "email": normalized, "name": character_name, "salt": salt, "hash": derive_key(password, salt).hex_encode(), "presets": [], "history": []}
	users.append(user)
	if not save_accounts():
		users.pop_back()
		return {"ok": false, "error": last_error}
	return {"ok": true, "account_id": user["id"]}

func login(email: String, password: String) -> Dictionary:
	var user := find_email(email)
	if user.is_empty() or not valid_password(password):
		return {"ok": false, "error": "Credenciais inválidas."}
	var expected: PackedByteArray = str(user["hash"]).hex_decode()
	if not crypto.constant_time_compare(expected, derive_key(password, str(user["salt"]))):
		return {"ok": false, "error": "Credenciais inválidas."}
	var token := crypto.generate_random_bytes(32).hex_encode()
	sessions[token] = {"id": user["id"], "expires": Time.get_unix_time_from_system() + SESSION_SECONDS}
	return {"ok": true, "token": token, "account_id": user["id"], "name": user["name"]}

func user_for_token(token: String) -> Dictionary:
	var session: Dictionary = sessions.get(token, {})
	if session.is_empty() or float(session["expires"]) <= Time.get_unix_time_from_system():
		sessions.erase(token)
		return {}
	return find_id(str(session["id"]))

func upsert_preset(token: String, preset_id: String, preset_name: String, class_id: String) -> Dictionary:
	var user := user_for_token(token)
	if user.is_empty() or not LocalProfileStore.valid_preset_name(preset_name) or not CLASS_IDS.has(class_id):
		return {"ok": false, "error": "Sessão ou configuração inválida."}
	var id := preset_id
	var found := false
	for i in range(user["presets"].size()):
		if user["presets"][i]["id"] == id:
			user["presets"][i] = {"id": id, "name": preset_name, "class_id": class_id}
			found = true
			break
	if not found:
		id = crypto.generate_random_bytes(16).hex_encode()
		user["presets"].append({"id": id, "name": preset_name, "class_id": class_id})
	if not save_accounts():
		return {"ok": false, "error": last_error}
	return {"ok": true, "id": id}
