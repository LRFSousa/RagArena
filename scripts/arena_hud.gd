extends Node2D
class_name ArenaHud

var arena: Node2D
const MINIMAP_RECT := Rect2(1055, 64, 190, 130)
const ITEM_FIRST_CENTER := Vector2(824, 465)
const ITEM_STEP := 94
const ITEM_RADIUS := 36.0
const SKILL_CENTERS := [Vector2(842, 608), Vector2(944, 564), Vector2(1044, 612)]
const SKILL_RADIUS := 41.0
const SWORDSMAN_ICONS := preload("res://assets/ui/swordsman/skill_icons_reference.png")
const SWORDSMAN_ICON_RECTS := [Rect2(45, 255, 340, 335), Rect2(415, 255, 340, 335), Rect2(783, 255, 337, 335), Rect2(1146, 255, 344, 335)]

func item_slot_at(point: Vector2) -> int:
	for i in range(arena.inventory.slots.size()):
		if point.distance_to(ITEM_FIRST_CENTER + Vector2(i * ITEM_STEP, 0)) <= ITEM_RADIUS:
			return i
	return -1

func skill_slot_at(point: Vector2) -> int:
	for i in range(3):
		if point.distance_to(SKILL_CENTERS[i]) <= SKILL_RADIUS:
			return i
	return -1

func _draw() -> void:
	if arena == null:
		return
	draw_rect(Rect2(0, 0, 1280, 52), Color("13242be8"))
	draw_rect(Rect2(12, 125, 440, 32), Color("13242bdc"))
	if arena.inventory != null:
		for i in range(arena.inventory.slots.size()):
			var slot: Dictionary = arena.inventory.slots[i]
			var center := ITEM_FIRST_CENTER + Vector2(i * ITEM_STEP, 0)
			draw_circle(center, ITEM_RADIUS, Color("14242edc"))
			draw_arc(center, ITEM_RADIUS, 0, TAU, 32, Color("9ab5ad"), 2)
			draw_string(ThemeDB.fallback_font, center + Vector2(-28, -20), str(i + 1), HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("c9ded8"))
			if slot["id"] != "":
				var icon: Texture2D = load("res://assets/pixel/%s.png" % slot["id"])
				draw_texture_rect(icon, Rect2(center - Vector2(18, 18), Vector2(36, 36)), false)
				if slot["quantity"] > 1:
					draw_string(ThemeDB.fallback_font, center + Vector2(17, 25), str(slot["quantity"]), HORIZONTAL_ALIGNMENT_LEFT, -1, 14, Color("ffe0a0"))
			else:
				draw_string(ThemeDB.fallback_font, center + Vector2(-17, 16), "+", HORIZONTAL_ALIGNMENT_CENTER, 34, 40, Color("c3dbe2"))
	draw_rect(Rect2(958, 250, 240, 52), Color("283d48"))
	draw_string(ThemeDB.fallback_font, Vector2(968, 283), "M Menu", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("f3f0df"))
	# Minimap provisório: mostra limites, área segura e jogador, sem revelar oponentes.
	var map_box := MINIMAP_RECT
	draw_rect(map_box, Color("13242be8"))
	draw_rect(map_box, Color("79bcb0"), false, 2)
	if arena.match_controller != null and arena.player != null:
		var world: Rect2 = arena.ARENA
		var inset := map_box.grow(-5)
		var safe: Rect2 = arena.match_controller.current_safe_rect
		var safe_box := Rect2(inset.position + (safe.position - world.position) / world.size * inset.size, safe.size / world.size * inset.size)
		draw_rect(safe_box, Color("83bda878"), false, 2)
		var dot: Vector2 = inset.position + (arena.player.position - world.position) / world.size * inset.size
		draw_circle(dot, 4, Color("fff1b3"))
	for i in range(3):
		var center: Vector2 = SKILL_CENTERS[i]
		draw_circle(center, SKILL_RADIUS, Color("182c36d9"))
		draw_arc(center, SKILL_RADIUS, 0, TAU, 40, Color("a5c6c7"), 2)
		if arena.combat != null and arena.combat.class_id == "paladin":
			draw_texture_rect_region(SWORDSMAN_ICONS, Rect2(center - Vector2(25, 25), Vector2(50, 50)), SWORDSMAN_ICON_RECTS[i + 1])
		else:
			draw_string(ThemeDB.fallback_font, center + Vector2(-8, 9), ["Q", "E", "F"][i], HORIZONTAL_ALIGNMENT_LEFT, -1, 24, Color("f3f0df"))
		draw_string(ThemeDB.fallback_font, center + Vector2(-34, -28), ["Q", "E", "F"][i], HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("f3f0df"))
		if arena.combat != null:
			if arena.combat.cooldowns[i] > 0.0:
				draw_circle(center, SKILL_RADIUS - 2, Color("07101899"))
				draw_string(ThemeDB.fallback_font, center + Vector2(-16, 7), "%.0fs" % arena.combat.cooldowns[i], HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color("f0d69c"))
	var base: Vector2 = arena.joystick_origin if arena.joystick_touch >= 0 else Vector2(130, 570)
	draw_circle(base, 73, Color(0.1, 0.17, 0.19, 0.45))
	draw_arc(base, 73, 0, TAU, 48, Color("72b9ab"), 3)
	draw_circle(base + arena.joystick_value * 55, 28, Color(0.34, 0.75, 0.67, 0.7))
	draw_circle(arena.ATTACK_CENTER, 68, Color(0.45, 0.17, 0.13, 0.8))
	draw_arc(arena.ATTACK_CENTER, 68, 0, TAU, 48, Color("e6a66d"), 4)
	if arena.combat != null and arena.combat.class_id == "paladin":
		draw_texture_rect_region(SWORDSMAN_ICONS, Rect2(arena.ATTACK_CENTER - Vector2(44, 44), Vector2(88, 88)), SWORDSMAN_ICON_RECTS[0])
	else:
		draw_string(ThemeDB.fallback_font, arena.ATTACK_CENTER + Vector2(-38, 7), "ATAQUE", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("fff1b3"))
	if arena.match_controller != null and arena.match_controller.state == "results":
		draw_rect(Rect2(350, 250, 580, 290), Color(0.05, 0.1, 0.14, 0.96))
		draw_rect(Rect2(350, 250, 580, 290), Color("d6b77b"), false, 4)
		draw_string(ThemeDB.fallback_font, Vector2(400, 310), "RESULTADO: %s" % arena.match_controller.result["winner"], HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color("fff1b3"))
		draw_string(ThemeDB.fallback_font, Vector2(400, 365), "Nível %d  |  XP %d  |  Caixas %d" % [arena.match_controller.result["level"], arena.match_controller.result["xp"], arena.match_controller.result["crates"]], HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("f3f0df"))
		draw_rect(Rect2(480, 430, 320, 70), Color("356f63"))
		draw_string(ThemeDB.fallback_font, Vector2(515, 475), "Nova partida (R)", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("f3f0df"))
