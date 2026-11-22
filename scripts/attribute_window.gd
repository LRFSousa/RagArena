extends Control
class_name AttributeWindow

signal closed

const Rules = preload("res://scripts/arena_attributes.gd")

var store: LocalProfileStore
var character_id := ""
var derived_stats: Dictionary = {}
var panel: PanelContainer
var content: VBoxContainer
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
	panel.custom_minimum_size = Vector2(780, 580)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("203139")
	style.border_color = Color("ba985d")
	style.set_border_width_all(3)
	style.set_content_margin_all(18)
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(740, 540)
	panel.add_child(scroll)
	content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 8)
	scroll.add_child(content)
	refresh()

func _label(value: String, size: int = 18, parent: Node = null) -> Label:
	var item := Label.new()
	item.text = value
	item.add_theme_font_size_override("font_size", size)
	item.add_theme_color_override("font_color", Color("f2eee0"))
	(parent if parent != null else content).add_child(item)
	return item

func refresh() -> void:
	if content == null:
		return
	for child in content.get_children():
		content.remove_child(child)
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
	_label("Os 48 pontos iniciais já formam os seis atributos 5. Bônus futuros: 0.", 15)
	for key in Rules.KEYS:
		var base := Rules.base_value(character, key)
		var bonus := Rules.bonus_value(character, key)
		var cost := Rules.next_cost(base)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 10)
		content.add_child(row)
		_label("%s    %d + %d = %d" % [Rules.LABELS[key], base, bonus, base + bonus], 19, row).custom_minimum_size = Vector2(325, 0)
		_label("Custo: %d" % cost, 17, row).custom_minimum_size = Vector2(150, 0)
		var add_button := Button.new()
		add_button.text = "+"
		add_button.custom_minimum_size = Vector2(65, 43)
		add_button.disabled = base >= 99 or int(character["attribute_points"]) < cost
		add_button.pressed.connect(_spend.bind(key))
		row.add_child(add_button)
	_label("Combate atual — valores provisórios; estes atributos ainda não alteram suas fórmulas.", 15)
	var derived := []
	for name in ["HP", "ATQ", "DEF", "Velocidade", "Alcance", "Cadência"]:
		if derived_stats.has(name):
			derived.append("%s: %s" % [name, str(derived_stats[name])])
	_label("  |  ".join(derived), 16)
	feedback = _label("", 15)

func _spend(key: String) -> void:
	if not store.spend_attribute_point(character_id, key):
		feedback.text = store.last_error
	else:
		refresh()
