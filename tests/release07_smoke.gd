extends SceneTree

const ArenaScene = preload("res://scenes/arena.tscn")
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(value: bool, label: String) -> void:
	if value:
		print("PASS: ", label)
	else:
		failures += 1
		push_error("FAIL: " + label)

func run_tests() -> void:
	for id in ["paladin", "mage", "assassin", "archer"]:
		var texture: Texture2D = load("res://assets/pixel/%s.png" % id)
		check(texture != null and texture.get_size() == Vector2(256, 320), "%s: atlas 4 × 5 em quadros 64" % id)
	for id in ["crate", "wall"]:
		var texture: Texture2D = load("res://assets/pixel/%s.png" % id)
		check(texture != null and texture.get_size() == Vector2(32, 32), "%s: tile 32" % id)
	for id in ["health_potion", "strength", "speed", "shield", "elixir", "xp_amulet"]:
		var texture: Texture2D = load("res://assets/pixel/%s.png" % id)
		check(texture != null and texture.get_size() == Vector2(16, 16), "%s: ícone de item" % id)
	var arena = ArenaScene.instantiate()
	root.add_child(arena)
	await process_frame
	check(arena.player.visual_sprite != null and arena.player.visual_sprite.texture != null, "personagem renderiza atlas")
	for id in ["mage", "assassin", "archer", "paladin"]:
		arena.player.set_visual_class(id)
		var expected := "ragnarena_espachim_walk_right.png" if id == "paladin" else "%s.png" % id
		check(arena.player.visual_class == id and arena.player.visual_sprite.texture.resource_path.ends_with(expected), "troca visual para %s" % id)
	arena.player.set_visual_class("mage")
	arena.player.show_attack()
	arena.player._physics_process(0.016)
	check(arena.player.visual_sprite.frame_coords.y == 2, "ataque mostra animação")
	arena.player.show_damage()
	arena.player._physics_process(0.016)
	check(arena.player.visual_sprite.frame_coords.y == 3, "dano tem prioridade visual")
	arena.player.visual_dead = true
	arena.player._physics_process(0.016)
	check(arena.player.visual_sprite.frame_coords.y == 4, "eliminação mostra animação")
	check(arena.hud_view.skill_slot_at(arena.ATTACK_CENTER) == -1 and arena.ATTACK_CENTER.distance_to(arena.hud_view.SKILL_CENTERS[2]) > arena.ATTACK_TOUCH_RADIUS + arena.hud_view.SKILL_RADIUS, "ataque separado das habilidades")
	check(arena.ATTACK_CENTER.distance_to(Vector2(130, 570)) > arena.ATTACK_TOUCH_RADIUS + 73.0, "ataque separado do joystick")
	check(arena.hud_view.item_slot_at(Vector2(824, 465)) == 0 and arena.hud_view.item_slot_at(Vector2(1106, 465)) == 3 and arena.hud_view.item_slot_at(Vector2(859, 500)) == -1, "poções circulares acima das habilidades")
	check(arena.hud_view.skill_slot_at(Vector2(842, 608)) == 0 and arena.hud_view.skill_slot_at(Vector2(944, 564)) == 1 and arena.hud_view.skill_slot_at(Vector2(1044, 612)) == 2 and arena.hud_view.skill_slot_at(Vector2(880, 646)) == -1, "habilidades circulares acompanham a composição mobile")
	check(arena.hud_view.SWORDSMAN_ICONS.get_size() == Vector2(1536, 1024) and arena.hud_view.SWORDSMAN_ICON_RECTS.size() == 4, "quatro ícones do Espadachim carregados no HUD")
	arena.inventory.pickup_item("health_potion")
	arena.inventory.hp = 40
	var item_touch := InputEventScreenTouch.new()
	item_touch.index = 5
	item_touch.pressed = true
	item_touch.position = Vector2(824, 465)
	arena._input(item_touch)
	check(arena.inventory.hp > 40 and arena.inventory.slots[0]["id"] == "", "toque no item usa poção")
	arena.combat.select_class("paladin")
	item_touch.position = Vector2(842, 608)
	arena._input(item_touch)
	check(arena.combat.cooldowns[0] > 0.0, "toque na habilidade inferior ativa Q")
	check(arena.player.skill_kind == 0 and arena.player.skill_flash > 0.0, "proteção inicia efeito visual")
	check("HP" in arena.hud.text and "Partida" in arena.status_hud.text, "HUD mostra vida e cronômetro")
	check(arena.hud_layer is CanvasLayer and arena.hud.get_parent() == arena.hud_layer and arena.hud_view.get_parent() == arena.hud_layer, "HUD independente das coordenadas do mundo")
	check(arena.camera is Camera2D and arena.camera.get_parent() == arena.player and arena.camera.zoom == Vector2(0.85, 0.85), "câmera afastada acompanha personagem")
	check(arena.ARENA.size == Vector2(2456, 1336) and not Rect2(0, 0, 1280, 720).has_point(arena.match_controller.SPAWNS[1]), "mapa e spawn ultrapassam uma tela")
	var touch := InputEventScreenTouch.new()
	touch.index = 4
	touch.pressed = true
	touch.position = arena.ATTACK_CENTER
	arena.player.position = Vector2(1800, 1000)
	arena._input(touch)
	check(arena.attack_held, "ataque continua em coordenadas de tela após mover no mundo")
	touch.pressed = false
	arena._input(touch)
	check(arena.game_audio.streams.size() == 4 and arena.game_audio.streams["pickup"].data.size() > 0, "efeitos de áudio disponíveis")
	arena.queue_free()
	await process_frame
	if failures == 0:
		print("RELEASE 0.7: todos os testes passaram")
	quit(0 if failures == 0 else 1)
