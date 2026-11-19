extends SceneTree

const Balance = preload("res://scripts/game_balance.gd")
const Progression = preload("res://scripts/progression.gd")
const Inventory = preload("res://scripts/player_inventory.gd")
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(condition: bool, message: String) -> void:
	if condition:
		print("PASS: ", message)
	else:
		failures += 1
		push_error("FAIL: " + message)

func run_tests() -> void:
	test_progression()
	test_inventory_and_effects()
	await test_arena_drops_and_collection()
	await test_slot_controls()
	await test_world_item_expiration()
	await test_restart()
	current_scene.queue_free()
	await process_frame
	if failures == 0:
		print("RELEASE 0.2: todos os testes passaram")
	quit(0 if failures == 0 else 1)

func test_progression() -> void:
	var balance = Balance.new()
	var progression = Progression.new()
	progression.configure(balance)
	check(progression.level == 1 and progression.xp_to_next() == 20, "nível inicial e primeira meta de XP")
	progression.grant_xp(20)
	check(progression.level == 2 and progression.xp == 0, "uma caixa sobe ao nível 2")
	check(progression.xp_to_next() == 24, "curva cresce após o nível 2")
	progression.grant_xp(20, 1.25)
	check(progression.level == 3 and progression.xp == 1, "amuleto concede 25% de XP")
	progression.grant_xp(1000000)
	check(progression.level == 30 and progression.xp_to_next() == 0, "progressão para no nível 30")
	check(progression.grant_xp(20) == 0, "não acumula XP após nível máximo")
	progression.configure(balance)
	check(progression.level == 1 and progression.xp == 0, "nova partida zera progressão")
	check(progression.grant_effective_pvp_damage_xp(0) == 0, "fonte PvP futura ignora dano nulo")
	progression.free()

func test_inventory_and_effects() -> void:
	var balance = Balance.new()
	var inventory = Inventory.new()
	inventory.configure(balance)
	check(inventory.slots.size() == 4 and inventory.hp == 100, "quatro slots e HP inicial")
	check(inventory.pickup_item("xp_amulet"), "amuleto ativa automaticamente")
	check(inventory.slots[0]["id"] == "" and is_equal_approx(inventory.xp_multiplier(), 1.25), "amuleto não ocupa slot")
	inventory.advance(5.0)
	inventory.pickup_item("xp_amulet")
	check(is_equal_approx(inventory.effect_remaining("xp_amulet"), 15.0), "nova coleta renova amuleto")
	inventory.advance(15.1)
	check(is_equal_approx(inventory.xp_multiplier(), 1.0), "amuleto expira")
	for i in range(3):
		check(inventory.pickup_item("health_potion"), "poção coletada para pilha")
	check(inventory.slots[0]["quantity"] == 3, "poções empilham até três")
	inventory.pickup_item("health_potion")
	check(inventory.slots[1]["id"] == "health_potion", "quarta poção abre novo slot")
	inventory.pickup_item("strength")
	inventory.pickup_item("speed")
	check(not inventory.pickup_item("shield"), "inventário cheio rejeita item manual")
	check(not inventory.use_slot(0), "cura não consome poção com HP cheio")
	inventory.apply_damage(50)
	check(inventory.use_slot(0) and inventory.hp == 80, "poção cura 30% do HP máximo")
	check(not inventory.use_slot(0), "cooldown global bloqueia uso imediato")
	inventory.advance(2.0)
	check(inventory.use_slot(0) and inventory.hp == 100, "cura respeita HP máximo")
	inventory.advance(2.0)
	check(inventory.use_slot(2) and is_equal_approx(inventory.pvp_damage_multiplier(), 1.2), "força aplica 20% ao futuro dano PvP")
	inventory.advance(15.1)
	check(is_equal_approx(inventory.pvp_damage_multiplier(), 1.0), "força expira")
	check(inventory.use_slot(3) and is_equal_approx(inventory.movement_speed_multiplier(), 1.15), "botas aplicam 15% de velocidade")
	inventory.advance(12.1)
	check(is_equal_approx(inventory.movement_speed_multiplier(), 1.0), "botas expiram")
	inventory.configure(balance)
	inventory.apply_damage(70)
	inventory.pickup_item("elixir")
	check(inventory.use_slot(0) and inventory.hp == 90, "elixir cura 60% do HP máximo")
	inventory.advance(2.0)
	inventory.pickup_item("shield")
	check(inventory.use_slot(0) and inventory.shield_points == 30, "escudo inicia com 30 pontos")
	check(inventory.apply_damage(20) == 0 and inventory.shield_points == 10, "escudo absorve dano antes do HP")
	check(inventory.apply_damage(15) == 5 and inventory.shield_points == 0, "escudo esgota e dano restante atinge HP")
	inventory.advance(2.0)
	inventory.pickup_item("strength")
	inventory.pickup_item("strength")
	inventory.use_slot(0)
	inventory.advance(5.0)
	check(inventory.use_slot(1), "buff igual pode ser reativado")
	check(is_equal_approx(inventory.effect_remaining("strength"), 15.0) and is_equal_approx(inventory.pvp_damage_multiplier(), 1.2), "buff igual renova duração sem somar potência")
	inventory.configure(balance)
	check(inventory.hp == 100 and inventory.slots[0]["id"] == "" and inventory.active.is_empty(), "nova partida limpa inventário e efeitos")
	inventory.free()

func load_arena() -> Node:
	change_scene_to_file("res://scenes/arena.tscn")
	await process_frame
	await process_frame
	var arena := current_scene
	var balance = Balance.new()
	arena.balance = balance
	arena.progression.configure(balance)
	arena.inventory.configure(balance)
	return arena

func find_crate(arena: Node, at_position: Vector2) -> StaticBody2D:
	for child in arena.get_children():
		if child is StaticBody2D and child.destructible and child.position == at_position:
			return child
	return null

func test_arena_drops_and_collection() -> void:
	var arena := await load_arena()
	arena.balance.drop_chance = 1.0
	arena.balance.drop_weights = {"xp_amulet": 1}
	var crate := find_crate(arena, Vector2(194, 290))
	crate.take_crate_damage(45)
	check(arena.progression.level == 2 and arena.destroyed_blocks == 1, "caixa destruída concede XP e nível")
	var amulet: GroundItem = null
	for child in arena.get_children():
		if child is GroundItem:
			amulet = child
	check(amulet != null and amulet.item_id == "xp_amulet", "drop ponderado gera item configurado")
	arena.player.position = Vector2(194, 290)
	arena.collect_ground_items()
	check(arena.inventory.effect_remaining("xp_amulet") > 0.0, "coleta automática ativa amuleto")
	check(arena.inventory.slots[0]["id"] == "", "amuleto coletado não usa inventário")
	var second := find_crate(arena, Vector2(410, 176))
	second.take_crate_damage(45)
	check(arena.progression.total_xp == 45, "amuleto aumenta XP da próxima caixa")
	arena.balance.drop_chance = 0.0
	var before := arena.get_children().filter(func(child): return child is GroundItem and not child.is_queued_for_deletion()).size()
	find_crate(arena, Vector2(490, 310)).take_crate_damage(45)
	var after := arena.get_children().filter(func(child): return child is GroundItem and not child.is_queued_for_deletion()).size()
	check(before == after, "chance zero não cria drop")
	await test_full_inventory_ground_item(arena)

func test_full_inventory_ground_item(arena: Node) -> void:
	arena.inventory.configure(arena.balance)
	for i in range(4):
		arena.inventory.pickup_item("strength")
	var ground: GroundItem = arena.spawn_ground_item("shield", arena.player.position)
	arena.collect_ground_items()
	check(not ground.is_queued_for_deletion(), "item fica no chão com inventário cheio")
	check(arena.inventory.use_slot(0), "uso manual libera um slot")
	arena.collect_ground_items()
	check(ground.is_queued_for_deletion() and arena.inventory.slots[0]["id"] == "shield", "item no chão é coletado após liberar espaço")
	await process_frame

func test_world_item_expiration() -> void:
	var arena := await load_arena()
	var item: GroundItem = arena.spawn_ground_item("speed", Vector2(600, 360))
	item.advance(20.0)
	check(item.is_queued_for_deletion(), "item no chão expira após 20 segundos")
	var other: GroundItem = arena.spawn_ground_item("shield", Vector2(900, 360))
	arena.remove_items_outside(Rect2(0, 0, 640, 720))
	check(other.is_queued_for_deletion(), "gancho de fechamento remove item fora da área")
	await process_frame

func test_slot_controls() -> void:
	var arena := await load_arena()
	arena.inventory.pickup_item("strength")
	var touch := InputEventScreenTouch.new()
	touch.index = 2
	touch.position = Vector2(60, 90)
	touch.pressed = true
	arena._input(touch)
	check(arena.inventory.effect_remaining("strength") > 0.0 and arena.joystick_touch == -1, "toque no slot usa item sem mover joystick")
	arena.inventory.advance(2.0)
	arena.inventory.pickup_item("speed")
	var key := InputEventKey.new()
	key.pressed = true
	key.physical_keycode = KEY_1
	arena._input(key)
	check(arena.inventory.effect_remaining("speed") > 0.0, "tecla 1 usa item do primeiro slot livre")

func test_restart() -> void:
	var arena := await load_arena()
	arena.progression.grant_xp(20)
	arena.inventory.pickup_item("strength")
	Input.action_press("restart")
	await physics_frame
	Input.action_release("restart")
	await process_frame
	await process_frame
	var restarted := current_scene
	check(restarted.progression.level == 1 and restarted.progression.xp == 0, "reinício zera nível e XP")
	check(restarted.inventory.slots[0]["id"] == "" and restarted.inventory.active.is_empty(), "reinício zera itens e efeitos")
