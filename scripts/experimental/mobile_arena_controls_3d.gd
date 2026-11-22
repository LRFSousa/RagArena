extends Control
class_name MobileArenaControls3D

signal action_pressed(action: String)

const ICONS := preload("res://assets/ui/swordsman/skill_icons_reference.png")
const ICON_RECTS := [Rect2(45, 255, 340, 335), Rect2(415, 255, 340, 335), Rect2(783, 255, 337, 335), Rect2(1146, 255, 344, 335)]
const POTION_TEXTURES := [preload("res://assets/pixel/health_potion.png"), preload("res://assets/pixel/elixir.png"), preload("res://assets/pixel/strength.png")]
const SKILLS := ["ESC", "CURA", "FOR"]
const POTIONS := ["POT_HP", "POT_ELIXIR", "POT_STRENGTH"]
const ACTIONS := ["POT_HP", "POT_ELIXIR", "POT_STRENGTH", "ALVO", "ESC", "CURA", "FOR", "ATK", "ZOOM_IN", "ZOOM_OUT"]

var arena: Node3D
var movement := Vector2.ZERO
var joystick_touch := -1
var _last_button := ""
var _last_button_time := 0
var visual_buttons: Dictionary = {}
var joystick_base: Panel
var joystick_thumb: Panel
var minimap_panel: Panel
var minimap_player: ColorRect
var minimap_targets: Array[ColorRect] = []

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_visuals()
	resized.connect(_layout_visuals)
	call_deferred("_layout_visuals")

func _circle_style(color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.border_color = Color("d7b46b")
	style.set_border_width_all(2)
	style.set_corner_radius_all(radius)
	return style

func _build_visuals() -> void:
	joystick_base = Panel.new()
	joystick_base.mouse_filter = Control.MOUSE_FILTER_IGNORE
	joystick_base.size = Vector2(146, 146)
	joystick_base.add_theme_stylebox_override("panel", _circle_style(Color("14242ecc"), 73))
	add_child(joystick_base)
	joystick_thumb = Panel.new()
	joystick_thumb.mouse_filter = Control.MOUSE_FILTER_IGNORE
	joystick_thumb.size = Vector2(58, 58)
	joystick_thumb.add_theme_stylebox_override("panel", _circle_style(Color("75b8b3"), 29))
	add_child(joystick_thumb)
	var captions := {"ATK": "ATK", "ESC": "Escudo", "CURA": "Cura", "FOR": "Força", "POT_HP": "HP", "POT_ELIXIR": "Elixir", "POT_STRENGTH": "Buff", "ALVO": "Alvo", "ZOOM_IN": "+", "ZOOM_OUT": "−"}
	for action in ACTIONS:
		var button := Button.new()
		button.name = "Acao" + action
		button.text = captions[action]
		button.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.focus_mode = Control.FOCUS_NONE
		button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.add_theme_font_size_override("font_size", 17 if action != "ATK" else 23)
		button.add_theme_color_override("font_color", Color.WHITE)
		button.add_theme_stylebox_override("normal", _circle_style(Color("733a2ae8") if action == "ATK" else Color("14242ee8"), 70))
		visual_buttons[action] = button
		add_child(button)
	minimap_panel = Panel.new()
	minimap_panel.name = "Minimapa"
	minimap_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	minimap_panel.add_theme_stylebox_override("panel", _circle_style(Color("13242be8"), 4))
	add_child(minimap_panel)
	var map_ground := ColorRect.new()
	map_ground.color = Color("77996c")
	map_ground.mouse_filter = Control.MOUSE_FILTER_IGNORE
	map_ground.position = Vector2(12, 12)
	map_ground.size = Vector2(186, 146)
	minimap_panel.add_child(map_ground)
	minimap_player = ColorRect.new()
	minimap_player.color = Color("fff1a7")
	minimap_player.size = Vector2(10, 10)
	minimap_player.mouse_filter = Control.MOUSE_FILTER_IGNORE
	minimap_panel.add_child(minimap_player)
	for i in range(3):
		var target := ColorRect.new()
		target.color = Color("f7a883")
		target.size = Vector2(7, 7)
		target.mouse_filter = Control.MOUSE_FILTER_IGNORE
		minimap_panel.add_child(target)
		minimap_targets.append(target)

func _layout_visuals() -> void:
	if size.x < 1 or size.y < 1 or joystick_base == null: return
	joystick_base.position = _joystick_center() - joystick_base.size * 0.5
	joystick_thumb.position = _joystick_center() + movement * 49 - joystick_thumb.size * 0.5
	for action in ACTIONS:
		var button: Button = visual_buttons[action]
		var diameter := _button_radius(action) * 2.0
		button.size = Vector2(diameter, diameter)
		button.position = _button_center(action) - button.size * 0.5
	minimap_panel.position = _map_rect().position
	minimap_panel.size = _map_rect().size

func _process(_delta: float) -> void:
	if joystick_thumb == null: return
	joystick_thumb.position = _joystick_center() + movement * 49 - joystick_thumb.size * 0.5
	if arena == null: return
	for i in range(POTIONS.size()):
		visual_buttons[POTIONS[i]].text = "%s\n%d" % [["HP", "Elixir", "Buff"][i], arena.potions[i]]
	for i in range(mini(minimap_targets.size(), arena.markers.size())):
		var marker: Node3D = arena.markers[i]
		minimap_targets[i].position = _map_point(Vector2(marker.global_position.x, marker.global_position.z), Rect2(12, 12, 186, 146)) - Vector2(3, 3)
	minimap_player.position = _map_point(Vector2(arena.actor.global_position.x, arena.actor.global_position.z), Rect2(12, 12, 186, 146)) - Vector2(5, 5)

func _joystick_center() -> Vector2:
	return Vector2(95, size.y - 105)

func _button_center(action: String) -> Vector2:
	var right := size.x
	var bottom := size.y
	match action:
		"ATK": return Vector2(right - 95, bottom - 92)
		"ESC": return Vector2(right - 270, bottom - 95)
		"CURA": return Vector2(right - 205, bottom - 175)
		"FOR": return Vector2(right - 112, bottom - 205)
		"POT_HP": return Vector2(right - 265, bottom - 290)
		"POT_ELIXIR": return Vector2(right - 185, bottom - 290)
		"POT_STRENGTH": return Vector2(right - 105, bottom - 290)
		"ALVO": return Vector2(right - 350, bottom - 95)
		"ZOOM_IN": return Vector2(right - 320, 245)
		"ZOOM_OUT": return Vector2(right - 265, 245)
		_: return Vector2.ZERO

func _button_radius(action: String) -> float:
	return 61.0 if action == "ATK" else 39.0 if action in SKILLS else 30.0

func _map_rect() -> Rect2:
	return Rect2(size.x - 228, 15, 210, 170)

func _draw() -> void:
	pass

func _label(value: String, point: Vector2, font_size: int) -> void:
	draw_string(ThemeDB.fallback_font, point, value, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.WHITE)

func _draw_minimap() -> void:
	var box := _map_rect()
	draw_rect(box, Color("13242be8"))
	draw_rect(box, Color("86b6aa"), false, 2)
	_label("ARENA", box.position + Vector2(10, 21), 16)
	if arena == null:
		return
	var inner := box.grow(-12)
	var regions: Array = arena.map_regions if arena.get("map_regions") != null else [Rect2(-12, 10, 24, 12), Rect2(-10, -7, 20, 10), Rect2(-7, -24, 14, 10)]
	for plateau in regions:
		draw_rect(_world_rect(plateau, inner), Color("77996c"))
	for i in range(arena.markers.size()):
		var marker: Node3D = arena.markers[i]
		draw_circle(_map_point(Vector2(marker.global_position.x, marker.global_position.z), inner), 4, Color("f7a883") if i == arena.selected_marker else Color("9dc5c1"))
	var player_point := _map_point(Vector2(arena.actor.global_position.x, arena.actor.global_position.z), inner)
	draw_circle(player_point, 5, Color("fff1a7"))
	var forward := Vector2(-arena.camera.global_basis.z.x, -arena.camera.global_basis.z.z).normalized()
	draw_line(player_point, player_point + forward * 12, Color("fff1a7"), 2)

func _world_rect(world: Rect2, inner: Rect2) -> Rect2:
	var bounds: Rect2 = arena.map_bounds if arena.get("map_bounds") != null else Rect2(-14, -25, 28, 48)
	return Rect2(_map_point(world.position, inner), world.size / bounds.size * inner.size)

func _map_point(world: Vector2, inner: Rect2) -> Vector2:
	var bounds: Rect2 = arena.map_bounds if arena.get("map_bounds") != null else Rect2(-14, -25, 28, 48)
	return inner.position + (world - bounds.position) / bounds.size * inner.size

func _input(event: InputEvent) -> void:
	if arena is Arena01Playtest and (is_instance_valid(arena.attribute_window) or is_instance_valid(arena.skill_window) or is_instance_valid(arena.inventory_window)):
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if _activate_button_at(event.position):
			get_viewport().set_input_as_handled()
		return
	if event is InputEventScreenTouch:
		if event.pressed:
			if event.position.distance_to(_joystick_center()) <= 95 and joystick_touch < 0:
				joystick_touch = event.index
				_set_joystick(event.position)
				get_viewport().set_input_as_handled()
				return
			if _activate_button_at(event.position):
				get_viewport().set_input_as_handled()
				return
		elif event.index == joystick_touch:
			joystick_touch = -1
			movement = Vector2.ZERO
			queue_redraw()
			get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag and event.index == joystick_touch:
		_set_joystick(event.position)
		get_viewport().set_input_as_handled()

func _activate_button_at(point: Vector2) -> bool:
	for action in ACTIONS:
		if point.distance_to(_button_center(action)) > _button_radius(action):
			continue
		var now := Time.get_ticks_msec()
		if action == _last_button and now - _last_button_time < 120:
			return true
		_last_button = action
		_last_button_time = now
		if action == "ZOOM_IN":
			arena.camera.zoom_by_steps(-1)
		elif action == "ZOOM_OUT":
			arena.camera.zoom_by_steps(1)
		else:
			action_pressed.emit(action)
		return true
	return false

func _set_joystick(point: Vector2) -> void:
	movement = ((point - _joystick_center()) / 65.0).limit_length(1.0)
	queue_redraw()
