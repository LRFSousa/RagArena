extends SceneTree

const Store = preload("res://scripts/local_profile_store.gd")
const SkillRules = preload("res://scripts/swordsman_skill_tree.gd")
const SkillPanel = preload("res://scripts/skill_window.gd")
const PATH := "res://tests/.swordsman_skills_test.json"

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	for suffix in ["", ".bak"]:
		if FileAccess.file_exists(PATH + suffix):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(PATH + suffix))
	var store := Store.new(PATH)
	assert(store.create_identity("ContaSkill"))
	var id := store.create_character("Espadachim01", "swordsman")
	var other := store.create_character("Espadachim02", "swordsman")
	assert(id != "" and other != "")
	var reward := store.settle_match(id, {"match_id": "arena-1", "active_seconds": 480, "kills": 5, "assists": 1, "completed_with_winner": true, "won": true})
	var character := store.find_character(id)
	assert(int(reward["job_levels"]) > 0 and int(character["skill_points"]) == int(character["job_level"]) - 1)
	assert(not store.spend_skill_point(id, "SM_MAGNUM"), "Impacto exige Golpe Fulminante 5")
	assert(not store.spend_skill_point(id, "SM_MOVINGRECOVERY"), "Skill de missão não usa ponto comum")
	assert(store.spend_skill_point(id, "SM_BASH"))
	assert(SkillRules.rank(character, "SM_BASH") == 1)
	assert(not store.spend_skill_point(id, "SM_MAGNUM"))
	for rank_number in range(2, 6):
		assert(store.spend_skill_point(id, "SM_BASH"), "Golpe Fulminante deve chegar ao rank 5")
	assert(SkillRules.rank(character, "SM_BASH") == 5)
	assert(store.spend_skill_point(id, "SM_MAGNUM"), "Impacto libera após Golpe Fulminante 5")
	assert(store.find_character(other)["skill_ranks"].is_empty())
	var panel := SkillPanel.new()
	panel.store = store
	panel.character_id = id
	root.add_child(panel)
	await process_frame
	assert(panel.lines.get_child_count() >= 8 and panel.list.get_child_count() >= 3 and panel.details.get_child_count() >= 7, "Janela mostra linhas, habilidades e detalhes")
	panel._select_line("defense")
	assert(panel.selected_skill == "SM_PROVOKE" and panel.list.get_child_count() >= 3)
	panel._select_line("combat")
	assert(panel.selected_skill == "SM_BASH")
	panel.queue_free()
	await process_frame
	var loaded := Store.new(PATH)
	assert(SkillRules.rank(loaded.find_character(id), "SM_BASH") == 5)
	assert(SkillRules.rank(loaded.find_character(id), "SM_MAGNUM") == 1)
	assert(loaded.settle_match(id, {"match_id": "arena-1", "active_seconds": 480}).is_empty(), "Partida não paga duas vezes")
	for suffix in ["", ".bak"]:
		if FileAccess.file_exists(PATH + suffix):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(PATH + suffix))
	print("swordsman_skills_smoke: OK")
	quit()
