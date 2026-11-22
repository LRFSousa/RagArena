extends Control
class_name AttributeWindow

signal closed
signal attribute_changed(character: Dictionary)

const Rules = preload("res://scripts/arena_attributes.gd")
const Derived = preload("res://scripts/arena_derived_stats.gd")

var store: LocalProfileStore
var character_id := ""
var derived_stats: Dictionary = {}
var panel: PanelContainer
var content: VBoxContainer
var overview: VBoxContainer
var feedback: Label

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var shade := ColorRect.new()
	shade.color = Color("07151bdc")
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(1050, 580)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("203139")
	style.border_color = Color("ba985d")
	style.set_border_width_all(3)
	style.set_content_margin_all(18)
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)
	var columns := HBoxContainer.new()
	columns.add_theme_constant_override("separation", 16)
	panel.add_child(columns)
	var primary_panel := PanelContainer.new()
	primary_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	primary_panel.add_theme_stylebox_override("panel", _inner_style(Color("263c46")))
	columns.add_child(primary_panel)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(490, 520)
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	primary_panel.add_child(scroll)
	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	scroll.add_child(content)
	var overview_panel := PanelContainer.new()
	overview_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overview_panel.add_theme_stylebox_override("panel", _inner_style(Color("e9f1f3")))
	columns.add_child(overview_panel)
	var right_scroll := ScrollContainer.new()
	right_scroll.custom_minimum_size = Vector2(450, 520)
	right_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	overview_panel.add_child(right_scroll)
	overview = VBoxContainer.new()
	overview.add_theme_constant_override("separation", 7)
	right_scroll.add_child(overview)
	refresh()

func _inner_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color("ba985d")
	style.set_border_width_all(1)
	style.set_content_margin_all(10)
	return style

func _label(value: String, size: int = 18, parent: Node = null, dark := false) -> Label:
	var item := Label.new()
	item.text = value
	item.add_theme_font_size_override("font_size", size)
	item.add_theme_color_override("font_color", Color("24313a") if dark else Color("f2eee0"))
	(parent if parent != null else content).add_child(item)
	return item

func refresh() -> void:
	if content == null:
		return
	for child in content.get_children():
		content.remove_child(child)
		child.queue_free()
	for child in overview.get_children():
		overview.remove_child(child)
		child.queue_free()
	var character := store.find_character(character_id) if store != null else {}
	if character.is_empty():
		_label("Personagem não encontrado.")
		return
	var header := HBoxContainer.new()
	content.add_child(header)
	_label("Atributos — %s" % str(character["name"]), 26, header).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var close_button := Button.new()
	close_button.text = "Fechar"
	close_button.custom_minimum_size = Vector2(95, 44)
	close_button.pressed.connect(func(): closed.emit())
	header.add_child(close_button)
	_label("Base %d  |  Job %d  |  Pontos de atributo: %d  |  Pontos de habilidade: %d" % [int(character["base_level"]), int(character["job_level"]), int(character["attribute_points"]), int(character["skill_points"])], 18)
	_label("Os 48 pontos iniciais formam os seis atributos 5.", 15)
	for key in Rules.KEYS:
		var base := Rules.base_value(character, key)
		var bonus := Rules.bonus_value(character, key)
		var cost := Rules.next_cost(base)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		content.add_child(row)
		_label("%s  %d + %d = %d" % [Rules.LABELS[key], base, bonus, base + bonus], 18, row).custom_minimum_size = Vector2(205, 0)
		_label("Custo: %d" % cost, 16, row).custom_minimum_size = Vector2(100, 0)
		var add_button := Button.new()
		add_button.text = "+"
		add_button.custom_minimum_size = Vector2(65, 43)
		add_button.disabled = base >= 99 or int(character["attribute_points"]) < cost
		add_button.pressed.connect(_spend.bind(key))
		row.add_child(add_button)
	feedback = _label("", 15)
	var stats := Derived.calculate(character)
	_label("Visão geral — atributos secundários", 24, overview, true)
	_label("Espadachim · Arena 01", 16, overview, true)
	for pair in [
		["HP máx.", "hp", "SP máx.", "sp"],
		["Reg. HP", "hp_regen", "Reg. SP", "sp_regen"],
		["ATK", "atk", "M.ATK", "matk"],
		["DEF", "def", "M.DEF", "mdef"],
		["Acerto", "hit", "Esquiva", "flee"],
		["Movimento", "move_speed", "Vel. ataque", "attack_speed"],
		["Alcance", "range", "", ""]
	]:
		var row := HBoxContainer.new()
		overview.add_child(row)
		_label("%s: %s" % [pair[0], str(stats[pair[1]])], 17, row, true).custom_minimum_size = Vector2(220, 0)
		if pair[2] != "":
			_label("%s: %s" % [pair[2], str(stats[pair[3]])], 17, row, true)
	_label("FOR: ATK · AGI: esquiva/ataque · VIT: HP/DEF", 14, overview, true)
	_label("INT: SP/M.ATK · DES: acerto · SOR: sorte", 14, overview, true)
	_label("Escala adaptada para arena; SP e demais secundários aguardam integração ao combate.", 14, overview, true)

func _spend(key: String) -> void:
	if not store.spend_attribute_point(character_id, key):
		feedback.text = store.last_error
	else:
		attribute_changed.emit(store.find_character(character_id))
		refresh()
