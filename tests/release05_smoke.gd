extends SceneTree

const Store = preload("res://scripts/local_profile_store.gd")
const MainScene = preload("res://scenes/main.tscn")
const TEST_PATH := "user://release05_profile_test.json"
const UI_PATH := "user://release05_ui_test.json"
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
	if FileAccess.file_exists(UI_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(UI_PATH))
	var entry = MainScene.instantiate()
	root.add_child(entry)
	entry.store = Store.new(UI_PATH)
	entry.show_login()
	var name_input: LineEdit
	var create_button: Button
	var keyboard_button: Button
	for child in entry.column.get_children():
		if child is LineEdit:
			name_input = child
		elif child is Button and child.text == "Criar personagem local":
			create_button = child
		elif child is Button and child.text == "Teclado na tela":
			keyboard_button = child
	keyboard_button.pressed.emit()
	check(is_instance_valid(entry.keyboard_panel), "teclado alternativo abre no formulário")
	var grid: GridContainer = entry.keyboard_panel.get_child(0).get_child(1)
	for wanted in ["N", "O", "M", "E", "_", "1", "Apagar", "2"]:
		for key in grid.get_children():
			if key.text == wanted:
				key.pressed.emit()
				break
	check(name_input.text == "NOME_2", "teclado alternativo digita e apaga caracteres")
	create_button.pressed.emit()
	check(entry.store.has_identity() and entry.column.get_child(0).text.contains("menu"), "formulário cria personagem e abre menu")
	entry.queue_free()
	await process_frame
	DirAccess.remove_absolute(ProjectSettings.globalize_path(UI_PATH))
	var store = Store.new(TEST_PATH)
	check(not store.has_identity(), "perfil inicia vazio")
	for invalid in ["ab", "nome longo demais 123", "com espaço", "áudio", "nome-hifen"]:
		check(not Store.valid_character_name(invalid), "nome inválido rejeitado: " + invalid)
	check(Store.valid_character_name("Heroi_123"), "nome ASCII válido")
	check(not store.create_identity("ab") and store.create_identity("Heroi_123"), "criação local valida nome")
	var account_id: String = store.data["account_id"]
	check(account_id.length() == 32 and not store.create_identity("Outro"), "ID interno separado e nome permanente")
	var first: String = store.create_preset("Escudo", "paladin")
	var second: String = store.create_preset("Cura", "paladin")
	check(first != "" and second != "" and first != second and store.data["presets"].size() == 2, "duas configurações da mesma classe")
	check(not store.data.has("hp") and not store.data.has("xp") and not store.data.has("inventory"), "perfil não guarda vantagem de partida")
	check(store.edit_preset(second, "Fogo", "mage") and store.find_preset(second)["class_id"] == "mage", "configuração renomeada e classe alterada")
	check(store.select_preset(second) and store.data["selected_id"] == second, "seleção persiste")
	var reloaded = Store.new(TEST_PATH)
	check(reloaded.has_identity() and reloaded.data["account_id"] == account_id and reloaded.data["character_name"] == "Heroi_123", "identidade persiste após nova instância")
	check(reloaded.data["presets"].size() == 2 and reloaded.data["selected_id"] == second, "configurações e seleção persistem")
	check(reloaded.delete_preset(first) and reloaded.data["presets"].size() == 1, "exclusão de configuração")
	var main = MainScene.instantiate()
	root.add_child(main)
	current_scene = main
	await process_frame
	main.store = reloaded
	main.show_login()
	check(main.screen.visible and main.column.get_child_count() > 2, "entrada local exibida")
	main.show_menu()
	check(main.column.get_child_count() >= 4, "menu Arena, Perfil e Configurações")
	main.show_presets(true)
	check(main.column.get_child_count() > 4, "seleção de configuração antes da arena")
	var preset_list: VBoxContainer
	for child in main.column.get_children():
		if child is ScrollContainer:
			preset_list = child.get_child(0)
	var play_button: Button = preset_list.get_child(0).get_child(1)
	play_button.pressed.emit()
	await physics_frame
	check(not main.screen.visible and main.arena.combat.class_id == "mage", "partida usa classe da configuração escolhida")
	var tab := InputEventKey.new()
	tab.pressed = true
	tab.physical_keycode = KEY_TAB
	main.arena._input(tab)
	check(main.arena.combat.class_id == "mage" and not main.arena.allow_class_change, "classe escolhida não muda durante partida normal")
	check(main.arena.progression.level == 1 and main.arena.progression.total_xp == 0 and main.arena.inventory.hp == main.arena.combat.max_hp() and main.arena.inventory.slots[0]["id"] == "", "partida começa sem progresso permanente")
	var old_arena = main.arena
	main.arena.progression.grant_xp(200)
	main.arena.inventory.pickup_item("shield")
	main.arena.match_controller.finish("time_limit", "Empate por tempo")
	check(main.store.data["history"].size() == 1 and main.store.data["history"][0]["preset_id"] == second, "resultado grava histórico local de teste")
	main.arena.restart_game()
	await process_frame
	await process_frame
	check(main.arena != old_arena and main.arena.progression.level == 1 and main.arena.inventory.slots[0]["id"] == "" and main.arena.combat.class_id == "mage", "nova partida limpa estado e mantém seleção")
	main.return_to_menu()
	await process_frame
	check(main.screen.visible and main.arena == null, "retorno ao menu")
	var reopened = Store.new(TEST_PATH)
	check(reopened.data["history"].size() == 1 and reopened.data["presets"].size() == 1, "histórico e configuração sobrevivem ao reinício")
	main.queue_free()
	await process_frame
	DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PATH))
	if failures == 0:
		print("RELEASE 0.5: todos os testes passaram")
	quit(0 if failures == 0 else 1)
