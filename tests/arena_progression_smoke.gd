extends SceneTree

const Progression = preload("res://scripts/arena_progression.gd")
const Store = preload("res://scripts/local_profile_store.gd")
const TEST_PATH := "res://../arena_progression_test.json"
const LEGACY_PATH := "res://../arena_progression_legacy_test.json"
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(value: bool, description: String) -> void:
	if value:
		print("PASS: ", description)
	else:
		failures += 1
		push_error("FAIL: " + description)

func clean(path: String) -> void:
	for suffix in ["", ".bak", ".v1.bak"]:
		var absolute := ProjectSettings.globalize_path(path + suffix)
		if FileAccess.file_exists(path + suffix):
			DirAccess.remove_absolute(absolute)

func run_tests() -> void:
	clean(TEST_PATH)
	clean(LEGACY_PATH)
	var config := Progression.new()
	check(config.last_error == "" and Progression.valid_config(config.config), "tabelas completas e válidas")
	check(config.level_for(899, "base") == 9 and config.level_for(900, "base") == 10, "marco Base 10")
	check(config.level_for(16500, "job") == 40 and config.capped_total(999999, "job") == 16500, "Job 40 e teto")
	var reward: Dictionary = config.reward({"active_seconds": 479.0, "kills": 7, "assists": 7, "effective_skills": 7, "completed_with_winner": true, "won": true})
	check(reward["minutes"] == 7 and reward["kills"] == 5 and reward["assists"] == 5 and reward["effective_skills"] == 5, "minutos completos e limites por evento")
	check(reward["base"] == 350 and reward["job"] == 285, "vitória e recompensas somadas")
	var death: Dictionary = config.reward({"active_seconds": 60.0, "kills": 1, "dead": true})
	check(death["base"] == 26 and death["job"] == 18, "morte aplica 25 por cento com arredondamento para baixo")
	var draw: Dictionary = config.reward({"active_seconds": 60.0, "completed_with_winner": false, "won": true})
	check(draw["base"] == 10 and draw["job"] == 5, "empate não paga conclusão nem vitória")
	var store := Store.new(TEST_PATH)
	check(store.create_identity("Conta_01"), "conta local criada")
	var first := store.create_character("Espada_01", "swordsman")
	var second := store.create_character("Mago_01", "mage")
	check(first != "" and second != "" and not store.create_character("Espada_01", "archer"), "personagens distintos e nome único")
	for i in range(7):
		check(store.create_character("Heroi_%d" % i, "archer") != "", "slot de personagem %d" % i)
	check(store.data["characters"].size() == 9 and store.create_character("Decimo", "thief") == "", "limite de nove personagens")
	var before_other: Dictionary = store.find_character(second).duplicate(true)
	var paid: Dictionary = store.settle_match(first, {"match_id": "partida-1", "active_seconds": 480.0, "kills": 2, "completed_with_winner": true, "won": true})
	check(not paid.is_empty() and paid["base_awarded"] == 210 and paid["job_awarded"] == 130, "recompensa persistente de arena")
	check(store.settle_match(first, {"match_id": "partida-1", "active_seconds": 480.0}).is_empty(), "mesma participação não paga duas vezes")
	check(store.find_character(second) == before_other, "EXP isolada entre personagens")
	store.settle_match(first, {"match_id": "partida-2", "active_seconds": 0.0, "kills": 5, "assists": 5, "effective_skills": 5, "completed_with_winner": true, "won": true})
	check(store.find_character(first)["base_level"] > 1 and store.find_character(first)["job_level"] > 1, "Base e Job sobem separadamente")
	var reloaded := Store.new(TEST_PATH)
	check(reloaded.find_character(first)["base_exp"] == store.find_character(first)["base_exp"] and reloaded.data["processed_matches"].size() == 2, "EXP e registro de pagamento sobrevivem ao reload")
	var damaged := FileAccess.open(TEST_PATH, FileAccess.WRITE)
	damaged.store_string("{")
	damaged.close()
	var recovered := Store.new(TEST_PATH)
	check(recovered.has_identity() and not recovered.find_character(first).is_empty() and recovered.data["processed_matches"].size() >= 1, "perfil recuperável por cópia anterior após corrupção")
	var legacy := {"version": 1, "account_id": "legacy-account", "character_name": "Antigo_01", "presets": [{"id": "p1", "name": "Mago", "class_id": "mage"}], "selected_id": "p1", "history": [{"winner": "Jogador"}]}
	var file := FileAccess.open(LEGACY_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(legacy))
	file.close()
	var migrated := Store.new(LEGACY_PATH)
	check(migrated.data["version"] == 2 and migrated.data["characters"].size() == 1 and migrated.data["characters"][0]["class_id"] == "mage", "perfil v1 migrado com classe selecionada")
	check(migrated.data["history"].size() == 1 and migrated.data["presets"].size() == 1 and FileAccess.file_exists(LEGACY_PATH + ".v1.bak"), "histórico, presets e cópia v1 preservados")
	clean(TEST_PATH)
	clean(LEGACY_PATH)
	quit(0 if failures == 0 else 1)
