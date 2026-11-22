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

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

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
	var center := _joystick_center()
	draw_circle(center, 73, Color("14242e88"))
	draw_arc(center, 73, 0, TAU, 40, Color("8ebbb2"), 3)
	draw_circle(center + movement * 49, 29, Color("75b8b3c9"))
	for action in ACTIONS:
		var point := _button_center(action)
		var radius := _button_radius(action)
		draw_circle(point, radius, Color("14242ecc") if action != "ATK" else Color("733a2acc"))
		draw_arc(point, radius, 0, TAU, 32, Color("d7b46b"), 2)
		if action == "ATK" or action in SKILLS:
			var icon_index := 0 if action == "ATK" else SKILLS.find(action) + 1
			draw_texture_rect_region(ICONS, Rect2(point - Vector2.ONE * (radius - 7), Vector2.ONE * (radius - 7) * 2), ICON_RECTS[icon_index])
		elif action in POTIONS:
			var index := POTIONS.find(action)
			draw_texture_rect(POTION_TEXTURES[index], Rect2(point - Vector2(18, 18), Vector2(36, 36)), false)
			if arena != null:
				_label(str(arena.potions[index]), point + Vector2(12, 24), 15)
		else:
			_label("O" if action == "ALVO" else "+" if action == "ZOOM_IN" else "-", point + Vector2(-10, 9), 25)
		if action in SKILLS and arena != null:
			var remaining: float = arena.skill_cooldowns[SKILLS.find(action)]
			if remaining > 0:
				draw_circle(point, radius - 2, Color("071018aa"))
				_label("%ds" % ceili(remaining), point + Vector2(-17, 8), 18)
	_draw_minimap()

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
	if arena is Arena01Playtest and (is_instance_valid(arena.attribute_window) or is_instance_valid(arena.skill_window)):
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
