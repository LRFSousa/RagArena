extends Control
class_name SkillWindow

signal closed

const SkillRules = preload("res://scripts/swordsman_skill_tree.gd")

var store: LocalProfileStore
var character_id := ""
var list: VBoxContainer
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
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(760, 580)
	var style := StyleBoxFlat.new()
	style.bg_color = Color("203139")
	style.border_color = Color("ba985d")
	style.set_border_width_all(3)
	style.set_content_margin_all(18)
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(720, 540)
	panel.add_child(scroll)
	list = VBoxContainer.new()
	list.add_theme_constant_override("separation", 8)
	scroll.add_child(list)
	refresh()

func _label(value: String, size: int = 17, parent: Node = null) -> Label:
	var item := Label.new()
	item.text = value
	item.add_theme_font_size_override("font_size", size)
	item.add_theme_color_override("font_color", Color("f2eee0"))
	(parent if parent != null else list).add_child(item)
	return item

func refresh() -> void:
	if list == null:
		return
	for child in list.get_children():
		list.remove_child(child)
		child.queue_free()
	var character := store.find_character(character_id) if store != null else {}
	if character.is_empty():
		_label("Personagem não encontrado.")
		return
	var header := HBoxContainer.new()
	list.add_child(header)
	_label("Habilidades", 26, header).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var close_button := Button.new()
	close_button.text = "Fechar"
	close_button.custom_minimum_size = Vector2(95, 44)
	close_button.pressed.connect(func(): closed.emit())
	header.add_child(close_button)
	_label("%s · Job %d · pontos disponíveis: %d" % [character["name"], character["job_level"], character["skill_points"]])
	if str(character["class_id"]) != "swordsman":
		_label("Árvore desta classe ainda não implementada.")
		return
	for skill in SkillRules.SKILLS:
		var id: String = skill["id"]
		var row := HBoxContainer.new()
		list.add_child(row)
		_label("%s  %d/%d" % [skill["name"], SkillRules.rank(character, id), skill["max"]], 17, row).custom_minimum_size = Vector2(390, 0)
		var add_button := Button.new()
		add_button.text = "+"
		add_button.custom_minimum_size = Vector2(60, 40)
		add_button.disabled = not SkillRules.can_spend(character, id)
		add_button.pressed.connect(_spend.bind(id))
		row.add_child(add_button)
		if not skill["requires"].is_empty():
			for prerequisite in skill["requires"]:
				_label("Requer %s %d" % [SkillRules.definition(prerequisite)["name"], skill["requires"][prerequisite]], 14)
	_label("Habilidades adicionais de missão (desbloqueio futuro):", 16)
	for skill in SkillRules.QUEST_SKILLS:
		_label("%s  0/1" % skill["name"], 15)
	feedback = _label("", 15)

func _spend(id: String) -> void:
	if store.spend_skill_point(character_id, id):
		refresh()
	else:
		feedback.text = store.last_error
