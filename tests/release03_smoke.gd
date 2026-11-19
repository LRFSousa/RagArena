extends SceneTree

const ArenaScene = preload("res://scenes/arena.tscn")
const ClassData = preload("res://scripts/class_balance.gd")
const CombatRules = preload("res://scripts/combat_rules.gd")
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		push_error("FAIL: " + label)

func run_tests() -> void:
	var data = ClassData.new()
	for class_id in ["paladin", "mage", "assassin", "archer"]:
		var stats: Dictionary = data.stats(class_id)
		check(stats.has("hp") and stats.has("damage") and stats.has("defense") and stats.has("range") and stats.has("speed") and stats.has("interval") and stats["cooldowns"].size() == 3, class_id + " possui atributos e três recargas")
	check(data.stats("paladin", 10)["hp"] > data.stats("paladin", 1)["hp"], "HP cresce por nível")
	check(data.skill_multiplier(9) == 1.0 and data.skill_multiplier(10) > 1.0 and data.skill_multiplier(30) > data.skill_multiplier(20), "marcos de habilidade 10/20/30")
	var arena = ArenaScene.instantiate()
	root.add_child(arena)
	current_scene = arena
	await physics_frame
	var combat = arena.combat
	for bot in combat.bots:
		bot.position = Vector2(1000, 600)
		bot.attack_time = 1000.0
	var target = combat.spawn_bot(Vector2(385, 300))
	target.attack_time = 1000.0
	arena.player.position = Vector2(300, 300)
	arena.player.facing = Vector2.RIGHT
	await physics_frame
	combat.select_class("paladin")
	var xp_before: int = arena.progression.total_xp
	var effective: int = combat.hit_bot(target, 999)
	check(effective == combat.settings.bot_hp, "dano efetivo não excede HP restante")
	check(arena.progression.total_xp == xp_before + effective + arena.balance.xp_per_elimination, "XP de dano efetivo e eliminação")
	check(combat.hit_bot(target, 999) == 0, "alvo eliminado não concede XP duplicado")
	var crate_target: StaticBody2D
	for child in arena.get_children():
		if child is StaticBody2D and child.destructible and child.position == Vector2(490, 310):
			crate_target = child
	check(crate_target != null, "caixa de teste de cadência presente")
	arena.player.position = Vector2(395, 310)
	arena.player.facing = Vector2.RIGHT
	await physics_frame
	for class_id in ["paladin", "mage", "assassin", "archer"]:
		combat.select_class(class_id)
		crate_target.hp = crate_target.max_hp
		var prior_hp: int = crate_target.hp
		arena.attack_timer = 0.0
		Input.action_press("attack")
		arena._physics_process(0.016)
		Input.action_release("attack")
		check(crate_target.hp == prior_hp - CombatRules.crate_damage(arena.progression.level) and is_equal_approx(arena.attack_timer, arena.attack_interval), class_id + " usa dano e cadência comum nas caixas")
	crate_target.hp = crate_target.max_hp
	arena.player.position = Vector2(300, 300)
	arena.player.facing = Vector2.RIGHT
	combat.select_class("paladin")
	combat.take_player_hit(20, true)
	check(arena.inventory.hp == combat.max_hp() - roundi((20 - int(combat.stats()["defense"])) * (1.0 - data.paladin_ranged_reduction)), "paladino reduz dano à distância")
	check(combat.use_skill(0) and arena.inventory.hp > 0, "paladino usa autocura")
	check(not combat.use_skill(0), "recarga impede spam")
	check(combat.use_skill(1) and combat.endure > 0.0, "paladino ativa determinação")
	var before_push: Vector2 = arena.player.position
	combat.take_player_hit(0, false, true)
	check(arena.player.position == before_push, "determinação impede empurrão")
	combat.select_class("mage")
	check(combat.use_skill(1) and combat.barrier > 0, "mago cria barreira")
	var hp_before: int = arena.inventory.hp
	combat.take_player_hit(10, true)
	check(arena.inventory.hp == hp_before and combat.barrier < data.mage_barrier_capacity, "barreira absorve dano")
	var frozen_bot = combat.spawn_bot(Vector2(385, 300))
	frozen_bot.attack_time = 1000.0
	check(combat.use_skill(0), "mago lança gelo")
	for i in range(8):
		await physics_frame
	check(frozen_bot.frozen > 0.0, "projétil de gelo aplica congelamento")
	check(combat.use_skill(2), "mago lança fogo")
	combat.select_class("assassin")
	check(combat.use_skill(0) and combat.use_skill(2), "invisibilidade combina com velocidade")
	check(combat.invisible > 0.0 and combat.swift > 0.0, "efeitos combinados permanecem ativos")
	combat.fire_basic()
	check(combat.invisible == 0.0, "invisibilidade termina ao atacar")
	check(combat.use_skill(1), "assassino lança lâmina")
	for bot in combat.bots:
		bot.position = Vector2(1000, 600)
	combat.select_class("archer")
	check(combat.use_skill(0), "arqueiro dispara rajada")
	check(combat.use_skill(1), "arqueiro dispara impacto")
	check(combat.use_skill(2), "arqueiro coloca armadilha")
	var traps := 0
	var placed_trap: CombatTrap
	for child in arena.get_children():
		if child is CombatTrap:
			traps += 1
			placed_trap = child
	check(traps == 1, "armadilha permanece na arena")
	var trapped_bot = combat.spawn_bot(placed_trap.position)
	trapped_bot.attack_time = 1000.0
	await physics_frame
	check(trapped_bot.rooted > 0.0, "armadilha imobiliza alvo que a aciona")
	check(combat.cooldowns[2] > 0.0 and not combat.use_skill(2), "recarga da armadilha")
	var blocked_bot = combat.spawn_bot(Vector2(560, 310))
	blocked_bot.attack_time = 1000.0
	arena.player.position = Vector2(395, 310)
	arena.player.facing = Vector2.RIGHT
	await physics_frame
	var crate: StaticBody2D
	for child in arena.get_children():
		if child is StaticBody2D and child.destructible and child.position == Vector2(490, 310):
			crate = child
	check(crate != null, "caixa de cobertura presente")
	var crate_hp: int = crate.hp
	combat.launch(Vector2.RIGHT, 20, 300.0, "test")
	for i in range(20):
		await physics_frame
	check(blocked_bot.hp == blocked_bot.max_hp and crate.hp == crate_hp, "caixa bloqueia projétil sem receber dano extra")
	var wall_bot = combat.spawn_bot(Vector2(700, 155))
	wall_bot.attack_time = 1000.0
	arena.player.position = Vector2(500, 155)
	await physics_frame
	combat.launch(Vector2.RIGHT, 20, 300.0, "test")
	for i in range(20):
		await physics_frame
	check(wall_bot.hp == wall_bot.max_hp, "parede bloqueia projétil")
	combat.select_class("paladin")
	check(combat.cooldowns == [0.0, 0.0, 0.0], "troca de classe limpa recargas no protótipo")
	arena.queue_free()
	await process_frame
	if failures == 0:
		print("RELEASE 0.3: todos os testes passaram")
	quit(0 if failures == 0 else 1)
