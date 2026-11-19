extends Node2D
class_name ArenaHud

var arena: Node2D

func _draw() -> void:
	if arena == null:
		return
	draw_rect(Rect2(0, 0, 1280, 52), Color("13242be8"))
	draw_rect(Rect2(12, 58, 438, 69), Color("13242bdc"))
	draw_rect(Rect2(12, 125, 440, 32), Color("13242bdc"))
	if arena.inventory != null:
		for i in range(arena.inventory.slots.size()):
			var slot: Dictionary = arena.inventory.slots[i]
			var origin := Vector2(24 + i * 105, 66)
			draw_rect(Rect2(origin, Vector2(98, 54)), Color(0.08, 0.14, 0.16, 0.85))
			draw_rect(Rect2(origin, Vector2(98, 54)), Color("79bcb0"), false, 2)
			var item_text: String = "vazio" if slot["id"] == "" else slot["id"].replace("health_potion", "Poção").replace("strength", "Força").replace("speed", "Botas").replace("shield", "Escudo").replace("elixir", "Elixir")
			draw_string(ThemeDB.fallback_font, origin + Vector2(7, 22), "%d %s" % [i + 1, item_text], HORIZONTAL_ALIGNMENT_LEFT, 90, 15, Color("f3f0df"))
			if slot["quantity"] > 1:
				draw_string(ThemeDB.fallback_font, origin + Vector2(74, 46), "x%d" % slot["quantity"], HORIZONTAL_ALIGNMENT_LEFT, 25, 15, Color("ffe0a0"))
	if arena.enable_debug_controls:
		for button in [[Rect2(958, 66, 100, 54), "H Dano"], [Rect2(1070, 66, 128, 54), "J Item"]]:
			draw_rect(button[0], Color(0.16, 0.2, 0.25, 0.88))
			draw_rect(button[0], Color("d6b77b"), false, 2)
			draw_string(ThemeDB.fallback_font, button[0].position + Vector2(10, 32), button[1], HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color("f3f0df"))
		if arena.allow_class_change or arena.match_controller != null and arena.match_controller.player_eliminated:
			draw_rect(Rect2(1055, 125, 143, 52), Color("283d48"))
			draw_string(ThemeDB.fallback_font, Vector2(1064, 157), "TAB Ver" if arena.match_controller != null and arena.match_controller.player_eliminated else "TAB Classe", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("f3f0df"))
		draw_rect(Rect2(958, 190, 240, 52), Color("283d48"))
		draw_string(ThemeDB.fallback_font, Vector2(968, 223), "T +60s teste", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("f3f0df"))
	draw_rect(Rect2(958, 250, 240, 52), Color("283d48"))
	draw_string(ThemeDB.fallback_font, Vector2(968, 283), "M Menu", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("f3f0df"))
	# Minimap provisório: mostra limites, área segura e jogador, sem revelar oponentes.
	var map_box := Rect2(1080, 320, 165, 96)
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
		var box := Rect2(730 + i * 108, 600, 98, 68)
		draw_rect(box, Color("284758"))
		draw_rect(box, Color("a5c6c7"), false, 2)
		draw_string(ThemeDB.fallback_font, box.position + Vector2(12, 28), ["Q", "E", "F"][i], HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("f3f0df"))
		if arena.combat != null:
			draw_string(ThemeDB.fallback_font, box.position + Vector2(36, 55), "%.0fs" % arena.combat.cooldowns[i] if arena.combat.cooldowns[i] > 0.0 else "PRONTO", HORIZONTAL_ALIGNMENT_LEFT, -1, 13, Color("f0d69c"))
	var base: Vector2 = arena.joystick_origin if arena.joystick_touch >= 0 else Vector2(130, 570)
	draw_circle(base, 73, Color(0.1, 0.17, 0.19, 0.45))
	draw_arc(base, 73, 0, TAU, 48, Color("72b9ab"), 3)
	draw_circle(base + arena.joystick_value * 55, 28, Color(0.34, 0.75, 0.67, 0.7))
	draw_circle(arena.ATTACK_CENTER, 66, Color(0.45, 0.17, 0.13, 0.8))
	draw_arc(arena.ATTACK_CENTER, 66, 0, TAU, 48, Color("e6a66d"), 4)
	draw_string(ThemeDB.fallback_font, arena.ATTACK_CENTER + Vector2(-38, 7), "ATAQUE", HORIZONTAL_ALIGNMENT_LEFT, -1, 16, Color("fff1b3"))
	if arena.match_controller != null and arena.match_controller.state == "results":
		draw_rect(Rect2(350, 250, 580, 290), Color(0.05, 0.1, 0.14, 0.96))
		draw_rect(Rect2(350, 250, 580, 290), Color("d6b77b"), false, 4)
		draw_string(ThemeDB.fallback_font, Vector2(400, 310), "RESULTADO: %s" % arena.match_controller.result["winner"], HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color("fff1b3"))
		draw_string(ThemeDB.fallback_font, Vector2(400, 365), "Nível %d  |  XP %d  |  Caixas %d" % [arena.match_controller.result["level"], arena.match_controller.result["xp"], arena.match_controller.result["crates"]], HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color("f3f0df"))
		draw_rect(Rect2(480, 430, 320, 70), Color("356f63"))
		draw_string(ThemeDB.fallback_font, Vector2(515, 475), "Nova partida (R)", HORIZONTAL_ALIGNMENT_LEFT, -1, 22, Color("f3f0df"))
