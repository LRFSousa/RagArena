extends Control
class_name SkillWindow

signal closed

const SkillRules = preload("res://scripts/swordsman_skill_tree.gd")

var store: LocalProfileStore
var character_id := ""
var selected_line := "combat"
var selected_skill := "SM_BASH"
var list: VBoxContainer
var lines: VBoxContainer
var details: VBoxContainer
var points_label: Label
var feedback: Label
var panel: PanelContainer
var close_button: Button

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var shade := ColorRect.new()
	shade.color = Color("0b0e13e8")
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(shade)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(1170, 640)
	panel.add_theme_stylebox_override("panel", _style(Color("242027"), 3, 15))
	center.add_child(panel)
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 10)
	panel.add_child(outer)
	var header := HBoxContainer.new()
	outer.add_child(header)
	_label("⚔  Habilidades", 25, header, Color("f4d292")).size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var character := store.find_character(character_id) if store != null else {}
	_label("Espadachim  •  Job %d" % int(character.get("job_level", 1)), 20, header).custom_minimum_size.x = 250
	points_label = _label("✦  Pontos disponíveis: %d" % int(character.get("skill_points", 0)), 19, header, Color("f4d292"))
	points_label.custom_minimum_size.x = 285
	points_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	close_button = Button.new()
	close_button.name = "FecharTopo"
	close_button.text = "✕"
	close_button.custom_minimum_size = Vector2(54, 44)
	close_button.pressed.connect(func(): closed.emit())
	header.add_child(close_button)
	var body := HBoxContainer.new()
	body.add_theme_constant_override("separation", 11)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	outer.add_child(body)
	lines = _column(body, 240)
	list = _column(body, 480)
	details = _column(body, 385)
	var footer := HBoxContainer.new()
	outer.add_child(footer)
	feedback = _label("", 14, footer, Color("ffbd8c"))
	feedback.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var close := Button.new()
	close.text = "Fechar"
	close.custom_minimum_size = Vector2(130, 44)
	close.pressed.connect(func(): closed.emit())
	footer.add_child(close)
	refresh()

func _style(color: Color, border: int = 1, margin: int = 9) -> StyleBoxFlat:
	var result := StyleBoxFlat.new()
	result.bg_color = color
	result.border_color = Color("bd9153")
	result.set_border_width_all(border)
	result.set_corner_radius_all(8)
	result.set_content_margin_all(margin)
	return result

func _column(parent: Node, width: float) -> VBoxContainer:
	var box := PanelContainer.new()
	box.custom_minimum_size.x = width
	box.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_theme_stylebox_override("panel", _style(Color("302930")))
	parent.add_child(box)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size.y = 495
	box.add_child(scroll)
	var column := VBoxContainer.new()
	column.custom_minimum_size.x = width - 25
	column.add_theme_constant_override("separation", 8)
	scroll.add_child(column)
	return column

func _label(value: String, size: int, parent: Node, color: Color = Color("f2eee0")) -> Label:
	var label := Label.new()
	label.text = value
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", color)
	parent.add_child(label)
	return label

func _clear(column: Node) -> void:
	for child in column.get_children():
		column.remove_child(child)
		child.queue_free()

func refresh() -> void:
	if list == null or store == null: return
	var character := store.find_character(character_id)
	if character.is_empty(): return
	points_label.text = "✦  Pontos disponíveis: %d" % int(character.get("skill_points", 0))
	_clear(lines)
	_clear(list)
	_clear(details)
	_label("Linhas de habilidades", 20, lines, Color("f4d292"))
	if str(character.get("class_id", "")) != "swordsman":
		_label("Árvore desta classe ainda não implementada.", 16, list)
		return
	for line_data in SkillRules.LINES:
		var line_id: String = line_data["id"]
		var button := Button.new()
		button.text = "%s  %s" % [line_data["icon"], line_data["name"]]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.custom_minimum_size.y = 56
		button.add_theme_font_size_override("font_size", 18)
		if line_id == selected_line: button.add_theme_stylebox_override("normal", _style(Color("84602e"), 2))
		button.pressed.connect(_select_line.bind(line_id))
		lines.add_child(button)
	for future_name in ["2ª Classe  🔒", "3ª Classe  🔒"]:
		var future := Button.new()
		future.text = future_name
		future.disabled = true
		future.custom_minimum_size.y = 52
		lines.add_child(future)
	var current_line := SkillRules.line(selected_line)
	_label("%s  %s" % [current_line.get("icon", ""), current_line.get("name", "")], 23, list, Color("f4d292"))
	for skill_id in current_line.get("skills", []):
		var id := str(skill_id)
		var definition := SkillRules.display_definition(id)
		var regular := SkillRules.definition(id)
		var rank := SkillRules.rank(character, id)
		var max_rank := int(definition.get("max", 1))
		var detail: Dictionary = SkillRules.DETAILS.get(id, {})
		var unlocked := regular.is_empty() == false and _prerequisites_met(character, regular)
		var card := PanelContainer.new()
		card.add_theme_stylebox_override("panel", _style(Color("56402c") if id == selected_skill else Color("3b3439")))
		list.add_child(card)
		var row := HBoxContainer.new()
		card.add_child(row)
		var select := Button.new()
		select.flat = true
		select.alignment = HORIZONTAL_ALIGNMENT_LEFT
		select.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		select.custom_minimum_size.y = 84
		select.text = "%s  %s\n    %s  •  %d/%d%s" % ["✦" if unlocked else "🔒", definition.get("name", id), detail.get("kind", "Futura"), rank, max_rank, "  •  bloqueada" if not unlocked else ""]
		select.add_theme_font_size_override("font_size", 17)
		select.pressed.connect(_select_skill.bind(id))
		row.add_child(select)
		var add := Button.new()
		add.text = "+"
		add.custom_minimum_size = Vector2(48, 48)
		add.disabled = not SkillRules.can_spend(character, id)
		add.pressed.connect(_spend.bind(id))
		row.add_child(add)
		if not regular.is_empty() and not regular["requires"].is_empty():
			_label(_requirement_text(regular), 13, list, Color("d6aa7a"))
	var selected := SkillRules.display_definition(selected_skill)
	if selected.is_empty(): return
	var selected_detail: Dictionary = SkillRules.DETAILS.get(selected_skill, {})
	_label(str(selected["name"]), 22, details, Color("f4d292"))
	_label(str(selected_detail.get("kind", "Habilidade futura")), 16, details, Color("d6aa7a"))
	_label("✦", 66, details, Color("efbf69"))
	var description := _label(str(selected_detail.get("text", "Desbloqueio ainda não definido para a arena.")), 17, details)
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if not selected_detail.is_empty():
		_label("Alcance: %s" % selected_detail.get("range", "—"), 16, details)
		_label("Custo: %s" % selected_detail.get("cost", "—"), 16, details)
	_label("Nível atual: %d/%d" % [SkillRules.rank(character, selected_skill), int(selected.get("max", 1))], 18, details, Color("f4d292"))
	if not SkillRules.definition(selected_skill).is_empty() and not selected["requires"].is_empty():
		_label(_requirement_text(selected), 15, details, Color("ffbd8c"))
	if selected_skill == "SM_BASH" and SkillRules.rank(character, selected_skill) < 10:
		_label("Próximo rank: %d%% ATK" % (130 + 30 * SkillRules.rank(character, selected_skill)), 15, details, Color("f4d292"))
	var learn := Button.new()
	learn.text = "Aprender +1"
	learn.custom_minimum_size.y = 53
	learn.disabled = not SkillRules.can_spend(character, selected_skill)
	learn.add_theme_stylebox_override("normal", _style(Color("a6752b"), 2))
	learn.pressed.connect(_spend.bind(selected_skill))
	details.add_child(learn)
	var note := _label("Ranks salvos; efeitos de combate 3D ainda em integração.", 13, details, Color("cdbb9d"))
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode in [KEY_ESCAPE, KEY_BACK]:
		closed.emit()
		get_viewport().set_input_as_handled()

func _prerequisites_met(character: Dictionary, skill: Dictionary) -> bool:
	for required_id in skill["requires"]:
		if SkillRules.rank(character, required_id) < int(skill["requires"][required_id]): return false
	return true

func _requirement_text(skill: Dictionary) -> String:
	var parts: Array[String] = []
	for required_id in skill["requires"]:
		parts.append("Requer %s %d" % [SkillRules.definition(required_id)["name"], int(skill["requires"][required_id])])
	return " · ".join(parts)

func _select_line(id: String) -> void:
	selected_line = id
	var definition := SkillRules.line(id)
	selected_skill = str(definition.get("skills", ["SM_BASH"])[0])
	refresh()

func _select_skill(id: String) -> void:
	selected_skill = id
	refresh()

func _spend(id: String) -> void:
	if store.spend_skill_point(character_id, id):
		refresh()
	else:
		feedback.text = store.last_error
