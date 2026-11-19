extends SceneTree

const Store = preload("res://scripts/server_account_store.gd")
const TEST_PATH := "user://release06_accounts_test.json"
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		push_error("FAIL: " + label)

func run_tests() -> void:
	if FileAccess.file_exists(TEST_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PATH))
	var accounts = Store.new(TEST_PATH)
	check(not Store.valid_email("sem-arroba") and not Store.valid_password("curta"), "email e senha curtos rejeitados")
	var created: Dictionary = accounts.register(" Teste@Exemplo.com ", "SenhaDeTesteMuitoForte123!", "Heroi_1")
	check(created.get("ok", false) and accounts.users.size() == 1, "conta criada com email normalizado")
	check(str(accounts.users[0]["email"]) == "teste@exemplo.com" and str(accounts.users[0]["id"]) != "Heroi_1", "ID separado de email e nome")
	check(not accounts.register("outro@exemplo.com", "SenhaDeTesteMuitoForte123!", "heroi_1").get("ok", true), "nome global duplicado ignora maiúsculas")
	check(not accounts.register("TESTE@EXEMPLO.COM", "SenhaDeTesteMuitoForte123!", "Heroi_2").get("ok", true), "email duplicado ignora maiúsculas")
	check(not accounts.login("teste@exemplo.com", "SenhaErradaMuitoForte123!").get("ok", true), "senha incorreta rejeitada")
	var logged: Dictionary = accounts.login("TESTE@EXEMPLO.COM", "SenhaDeTesteMuitoForte123!")
	check(logged.get("ok", false) and accounts.user_for_token(str(logged.get("token", "")))["id"] == created["account_id"], "login emite sessão vinculada à conta")
	check(accounts.user_for_token("token-inventado").is_empty(), "token inventado rejeitado")
	var preset: Dictionary = accounts.upsert_preset(str(logged["token"]), "", "Minha defesa", "paladin")
	check(preset.get("ok", false) and accounts.find_id(str(created["account_id"]))["presets"].size() == 1, "preset só é salvo com sessão válida")
	check(not accounts.upsert_preset("token-inventado", "", "Outro", "mage").get("ok", true), "preset sem sessão rejeitado")
	var file := FileAccess.open(TEST_PATH, FileAccess.READ)
	var saved := file.get_as_text()
	check(not saved.contains("SenhaDeTesteMuitoForte123!") and saved.contains("salt") and saved.contains("hash"), "senha não é armazenada em texto simples")
	var reloaded = Store.new(TEST_PATH)
	check(reloaded.users.size() == 1 and reloaded.users[0]["presets"].size() == 1, "conta e preset persistem no servidor")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PATH))
	if failures == 0:
		print("RELEASE 0.6 CONTAS: todos os testes passaram")
	quit(0 if failures == 0 else 1)
