extends SceneTree

const Store = preload("res://scripts/local_profile_store.gd")
const Rules = preload("res://scripts/arena_attributes.gd")
const PanelScript = preload("res://scripts/attribute_window.gd")
const TEST_PATH := "res://tests/.arena_attributes_test.json"
const LEGACY_PATH := "res://tests/.arena_attributes_v2_test.json"
var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func check(ok: bool, message: String) -> void:
	if ok:
		print("PASS: ", message)
	else:
		failures += 1
		push_error("FAIL: " + message)

func clean(path: String) -> void:
	for suffix in ["", ".bak", ".v1.bak"]:
		if FileAccess.file_exists(path + suffix):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path + suffix))

func _run() -> void:
	clean(TEST_PATH)
	clean(LEGACY_PATH)
	var rules := Rules.new()
	check(rules.last_error == "" and Rules.valid_config(rules.config), "tabela configurável válida")
	check(rules.total_at(1) == 48 and rules.total_at(10) == 80 and rules.total_at(20) == 135 and rules.total_at(30) == 210 and rules.total_at(40) == 305, "marcos da referência até Base 40")
	check(rules.points_between(1, 10) == 32 and rules.points_between(39, 40) == 10, "concessão usa diferença entre níveis")
	check(Rules.next_cost(5) == 2 and Rules.next_cost(10) == 2 and Rules.next_cost(11) == 3, "custo progressivo Pre-Renewal")
	var store := Store.new(TEST_PATH)
	check(store.create_identity("Conta_Atributos"), "conta criada")
	var first := store.create_character("Espada_01", "swordsman")
	var second := store.create_character("Mago_01", "mage")
	check(first != "" and second != "" and store.find_character(first)["attribute_points"] == 0 and store.find_character(first)["attributes"] == Rules.initial_values(), "48 pontos iniciais já usados na criação")
	var other_before := store.find_character(second).duplicate(true)
	var paid := store.settle_match(first, {"match_id": "atributos-1", "active_seconds": 480, "kills": 5, "assists": 5, "effective_skills": 5, "completed_with_winner": true, "won": true})
	var character := store.find_character(first)
	check(not paid.is_empty() and paid["base_levels"] > 1 and paid["job_levels"] > 1, "recompensa sobe múltiplos níveis")
	check(int(character["attribute_points"]) == rules.total_at(int(character["base_level"])) - 48 and int(character["skill_points"]) == int(character["job_level"]) - 1, "pontos Base e Job concedidos em todos os marcos")
	check(store.settle_match(first, {"match_id": "atributos-1", "active_seconds": 480}).is_empty() and character["attribute_points"] == paid["attribute_points_awarded"], "pagamento duplicado não concede pontos")
	check(store.find_character(second) == other_before, "segundo personagem mantém progressão própria")
	var old_balance := int(character["attribute_points"])
	check(store.spend_attribute_point(first, "for") and Rules.base_value(character, "for") == 6 and int(character["attribute_points"]) == old_balance - 2, "distribuição consome custo do próximo incremento")
	check(not store.spend_attribute_point(first, "invalido"), "atributo inválido recusado")
	var window := PanelScript.new()
	window.store = store
	window.character_id = first
	window.derived_stats = {"HP": 100, "ATQ": 20}
	root.add_child(window)
	await process_frame
	check(window.content != null and window.content.get_child_count() >= 10 and window.overview.get_child_count() >= 9, "janelas de atributos e secundários renderizam juntas")
	var row: HBoxContainer = window.content.get_child(3)
	var add_button: Button = row.get_child(2)
	check(not add_button.disabled, "botão habilitado quando há saldo")
	add_button.pressed.emit()
	check(Rules.base_value(character, "for") == 7, "botão da janela distribui ponto e atualiza perfil")
	window.queue_free()
	await process_frame
	var reloaded := Store.new(TEST_PATH)
	check(reloaded.find_character(first)["attributes"]["for"] == 7 and reloaded.find_character(first)["skill_points"] == character["skill_points"], "atributos e pontos persistem após recarregar")
	for i in range(120):
		store.settle_match(first, {"match_id": "ate-40-%d" % i, "active_seconds": 480, "kills": 5, "assists": 5, "effective_skills": 5, "completed_with_winner": true, "won": true})
		if int(character["base_level"]) == 40 and int(character["job_level"]) == 40:
			break
	check(int(character["base_level"]) == 40 and int(character["job_level"]) == 40, "ambas as trilhas respeitam limite 40")
	check(int(character["attribute_points"]) == 305 - 48 - 4 and int(character["skill_points"]) == 39, "saldo até o teto não duplica concessões")
	var balance_at_cap := int(character["attribute_points"])
	store.settle_match(first, {"match_id": "apos-teto", "active_seconds": 480, "kills": 5, "assists": 5, "effective_skills": 5, "completed_with_winner": true, "won": true})
	check(int(character["attribute_points"]) == balance_at_cap and store.find_character(second) == other_before, "recompensa após teto não concede pontos; personagens isolados")
	var legacy := Store.new_character("legado", "Legado_01", "swordsman")
	for key in ["attributes", "attribute_points", "skill_points", "attribute_awarded_through_level", "skill_awarded_through_level"]:
		legacy.erase(key)
	legacy["base_level"] = 20
	legacy["job_level"] = 12
	var old_profile := store.empty_profile()
	old_profile["version"] = 2
	old_profile["account_id"] = "conta-legada"
	old_profile["character_name"] = "Conta_Legada"
	old_profile["characters"] = [legacy]
	old_profile["selected_character_id"] = "legado"
	var file := FileAccess.open(LEGACY_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(old_profile))
	file.close()
	var migrated := Store.new(LEGACY_PATH)
	var migrated_character := migrated.find_character("legado")
	check(migrated.data["version"] == 3 and migrated_character["attribute_points"] == 87 and migrated_character["skill_points"] == 11, "perfil v2 recebe marcos antigos uma vez")
	var migrated_again := Store.new(LEGACY_PATH)
	check(migrated_again.find_character("legado")["attribute_points"] == 87 and FileAccess.file_exists(LEGACY_PATH + ".bak"), "migração idempotente com cópia de segurança")
	clean(TEST_PATH)
	clean(LEGACY_PATH)
	quit(0 if failures == 0 else 1)
