extends SceneTree

const MainScene = preload("res://scenes/main.tscn")
const Store = preload("res://scripts/local_profile_store.gd")
const TEST_PATH := "res://../arena_participation_test.json"
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(value: bool, description: String) -> void:
	if value:
		print("PASS: ", description)
	else:
		failures += 1
		push_error("FAIL: " + description)

func run_tests() -> void:
	for suffix in ["", ".bak"]:
		if FileAccess.file_exists(TEST_PATH + suffix):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PATH + suffix))
	var main = MainScene.instantiate()
	root.add_child(main)
	current_scene = main
	main.store = Store.new(TEST_PATH)
	check(main.store.create_identity("Conta_Test"), "conta criada")
	var character_id: String = main.store.create_character("Espada_Test", "swordsman")
	check(character_id != "", "Espadachim criado")
	main.start_match(character_id)
	await physics_frame
	main.arena.match_controller.elapsed = 125.0
	main.arena.match_controller.register_elimination(42)
	main.arena.match_controller.register_elimination(42)
	main.arena.match_controller.register_assist(43)
	main.arena.match_controller.register_effective_skill(1)
	main.arena.match_controller.register_effective_skill(1)
	main.arena.inventory.hp = 0
	main.arena.match_controller.advance(0.0)
	await process_frame
	check(main.store.data["history"].size() == 1 and main.store.data["history"][0]["base_reward"] == 45 and main.store.data["history"][0]["job_reward"] == 37, "morte encerra participação e paga uma vez com penalidade")
	check(main.screen.visible and main.column.get_child(0).text.contains("personagem"), "morte retorna à seleção")
	main.start_match(character_id)
	await physics_frame
	main.arena.match_controller.elapsed = 480.0
	main.arena.match_controller.finish("time_limit", "Empate por tempo")
	check(main.store.data["history"].size() == 2 and main.store.data["history"][1]["base_reward"] == 80 and main.store.data["history"][1]["job_reward"] == 40, "tempo sem vencedor paga apenas participação")
	main.start_match(character_id)
	await physics_frame
	main.arena.match_controller.elapsed = 480.0
	main.arena.match_controller.finish("last_survivor", "Jogador")
	check(main.store.data["history"].size() == 3 and main.store.data["history"][2]["base_reward"] == 160 and main.store.data["history"][2]["job_reward"] == 90, "vitória paga participação, conclusão e bônus")
	check(main.store.find_character(character_id)["base_exp"] == 285 and main.store.find_character(character_id)["job_exp"] == 167, "EXP acumulada preservada entre arenas")
	main.start_match(character_id)
	await physics_frame
	main.arena.match_controller.elapsed = 125.0
	main.arena.match_controller.register_elimination(77)
	main.return_to_menu()
	check(main.store.data["history"].size() == 4 and main.store.data["history"][3]["base_reward"] == 45 and main.store.data["history"][3]["job_reward"] == 30, "abandono preserva ações válidas sem penalidade de morte")
	main.queue_free()
	await process_frame
	for suffix in ["", ".bak"]:
		if FileAccess.file_exists(TEST_PATH + suffix):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PATH + suffix))
	quit(0 if failures == 0 else 1)
