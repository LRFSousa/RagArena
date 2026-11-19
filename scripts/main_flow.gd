extends Node2D
class_name MainFlow

const ArenaScene = preload("res://scenes/arena.tscn")
const ProfileStore = preload("res://scripts/local_profile_store.gd")
const CLASS_IDS := ["paladin", "mage", "assassin", "archer"]
const CLASS_NAMES := ["Paladino", "Mago", "Assassino", "Arqueiro"]

var store: LocalProfileStore
var screen: Control
var column: VBoxContainer
var arena: Node2D
var current_preset_id := ""
var edit_id := ""
var keyboard_panel: PanelContainer

func _ready() -> void:
	store = ProfileStore.new()
	screen = Control.new()
	screen.size = Vector2(1280, 720)
	add_child(screen)
	show_login()

func make_screen(title: String) -> void:
	for child in screen.get_children():
		child.queue_free()
	keyboard_panel = null
	var background := ColorRect.new()
	background.color = Color("192d2d")
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	screen.add_child(background)
	column = VBoxContainer.new()
	column.position = Vector2(220, 72)
	column.custom_minimum_size = Vector2(840, 0)
	column.add_theme_constant_override("separation", 12)
	screen.add_child(column)
	label(title, 34)

func label(value: String, size := 20, parent: Node = null) -> Label:
	var item := Label.new()
	item.text = value
	item.add_theme_font_size_override("font_size", size)
	item.add_theme_color_override("font_color", Color("f3f0df"))
	(parent if parent != null else column).add_child(item)
	return item

func button(value: String, action: Callable, parent: Node = null) -> Button:
	var item := Button.new()
	item.text = value
	item.custom_minimum_size = Vector2(0, 52)
	item.add_theme_font_size_override("font_size", 20)
	item.pressed.connect(action)
	(parent if parent != null else column).add_child(item)
	return item

func text_field(placeholder: String, parent: Node = null) -> LineEdit:
	var item := LineEdit.new()
	item.placeholder_text = placeholder
	item.custom_minimum_size = Vector2(0, 46)
	item.add_theme_font_size_override("font_size", 20)
	(parent if parent != null else column).add_child(item)
	return item

func show_virtual_keyboard(input: LineEdit) -> void:
	if is_instance_valid(keyboard_panel):
		keyboard_panel.queue_free()
	keyboard_panel = PanelContainer.new()
	keyboard_panel.position = Vector2(180, 375)
	keyboard_panel.size = Vector2(920, 300)
	screen.add_child(keyboard_panel)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	keyboard_panel.add_child(content)
	label("Digite pelo teclado da tela; use Concluir para voltar.", 18, content)
	var keys := GridContainer.new()
	keys.columns = 10
	keys.add_theme_constant_override("h_separation", 4)
	keys.add_theme_constant_override("v_separation", 4)
	content.add_child(keys)
	for token in ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S", "D", "F", "G", "H", "J", "K", "L", "_", "Z", "X", "C", "V", "B", "N", "M"]:
		var key := Button.new()
		key.text = token
		key.custom_minimum_size = Vector2(82, 48)
		key.pressed.connect(func(): apply_virtual_key(input, token))
		keys.add_child(key)
	for special in ["Espaço", "Apagar", "Concluir"]:
		var key := Button.new()
		key.text = special
		key.custom_minimum_size = Vector2(82, 48)
		key.pressed.connect(func(): apply_virtual_key(input, special))
		keys.add_child(key)

func apply_virtual_key(input: LineEdit, token: String) -> void:
	match token:
		"Espaço": input.text += " "
		"Apagar": input.text = input.text.substr(0, maxi(0, input.text.length() - 1))
		"Concluir":
			if is_instance_valid(keyboard_panel):
				keyboard_panel.queue_free()
			keyboard_panel = null
		_: input.text += token

func show_login() -> void:
	screen.show()
	make_screen("RagnArena — entrada local")
	label("Protótipo offline. Este perfil fica salvo apenas neste dispositivo.")
	if store.has_identity():
		label("Personagem: %s" % store.data["character_name"])
		button("Entrar localmente", show_menu)
	else:
		var name_input := text_field("Nome do personagem (3–16 letras, números ou _)")
		button("Teclado na tela", func(): show_virtual_keyboard(name_input))
		var feedback := label("", 16)
		button("Criar personagem local", func():
			if store.create_identity(name_input.text):
				show_menu()
			else:
				feedback.text = store.last_error)
	if store.last_error != "":
		label(store.last_error, 16)

func show_menu() -> void:
	screen.show()
	make_screen("RagnArena — menu")
	label("%s  |  Perfil local" % store.data["character_name"])
	button("Arena", func(): show_presets(true))
	button("Perfil", show_profile)
	button("Configurações", func(): show_presets(false))

func show_profile() -> void:
	make_screen("Perfil")
	label("Personagem: %s" % store.data["character_name"])
	label("ID local: %s" % str(store.data["account_id"]).substr(0, 12), 16)
	label("Partidas registradas neste dispositivo: %d" % store.data["history"].size())
	var history: Array = store.data["history"]
	for i in range(history.size() - 1, maxi(-1, history.size() - 6), -1):
		var entry: Dictionary = history[i]
		label("%s | %s | nível %d | XP %d" % [entry.get("played_at", ""), entry.get("winner", ""), entry.get("level", 1), entry.get("xp", 0)], 16)
	button("Voltar", show_menu)

func show_presets(for_arena: bool) -> void:
	edit_id = ""
	make_screen("Escolha a configuração" if for_arena else "Configurações salvas")
	label("Cada configuração guarda somente nome e classe.", 18)
	var name_input := text_field("Nome da configuração")
	button("Teclado na tela", func(): show_virtual_keyboard(name_input))
	var class_picker := OptionButton.new()
	class_picker.custom_minimum_size = Vector2(0, 48)
	for name in CLASS_NAMES:
		class_picker.add_item(name)
	column.add_child(class_picker)
	var feedback := label("", 16)
	button("Criar / salvar edição", func():
		var class_id: String = CLASS_IDS[class_picker.selected]
		var saved := false
		if edit_id == "":
			saved = store.create_preset(name_input.text, class_id) != ""
		else:
			saved = store.edit_preset(edit_id, name_input.text, class_id)
		if saved:
			show_presets(for_arena)
		else:
			feedback.text = store.last_error)
	var scroller := ScrollContainer.new()
	scroller.custom_minimum_size = Vector2(840, 180)
	column.add_child(scroller)
	var list := VBoxContainer.new()
	list.custom_minimum_size = Vector2(820, 0)
	list.add_theme_constant_override("separation", 8)
	scroller.add_child(list)
	if store.data["presets"].is_empty():
		label("Crie uma configuração para entrar na arena.", 18, list)
	for preset in store.data["presets"]:
		var id: String = preset["id"]
		var row := HBoxContainer.new()
		list.add_child(row)
		var class_index := CLASS_IDS.find(str(preset["class_id"]))
		label("%s — %s%s" % [preset["name"], CLASS_NAMES[maxi(0, class_index)], "  ✓" if store.data["selected_id"] == id else ""], 18, row).custom_minimum_size = Vector2(330, 0)
		button("Jogar" if for_arena else "Selecionar", func():
			if for_arena:
				start_match(id)
			else:
				store.select_preset(id)
				show_presets(false), row)
		button("Editar", func():
			edit_id = id
			name_input.text = str(preset["name"])
			class_picker.select(maxi(0, CLASS_IDS.find(str(preset["class_id"])))), row)
		button("Excluir", func():
			store.delete_preset(id)
			show_presets(for_arena), row)
	button("Voltar ao menu", show_menu)

func start_match(preset_id: String) -> void:
	var preset := store.find_preset(preset_id)
	if preset.is_empty() or not store.select_preset(preset_id):
		return
	current_preset_id = preset_id
	if is_instance_valid(arena):
		arena.queue_free()
	arena = ArenaScene.instantiate()
	arena.allow_class_change = false
	arena.enable_debug_controls = false
	add_child(arena)
	arena.combat.select_class(str(preset["class_id"]))
	arena.restart_requested.connect(_restart_match)
	arena.menu_requested.connect(return_to_menu)
	arena.match_controller.match_ended.connect(_on_match_ended)
	screen.hide()

func _on_match_ended(result: Dictionary) -> void:
	store.record_result(result, current_preset_id)

func _restart_match() -> void:
	call_deferred("start_match", current_preset_id)

func return_to_menu() -> void:
	if is_instance_valid(arena):
		arena.queue_free()
		arena = null
	show_menu()
