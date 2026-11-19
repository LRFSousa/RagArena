extends SceneTree

const ArenaScene = preload("res://scenes/arena.tscn")
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
	var arena = ArenaScene.instantiate()
	root.add_child(arena)
	current_scene = arena
	await physics_frame
	var combat = arena.combat
	for initial_bot in combat.bots:
		initial_bot.attack_time = 1000.0
	var full_hp: int = arena.inventory.hp
	arena.player.position = Vector2(300, 300)
	for i in range(100):
		await physics_frame
	check(arena.inventory.hp == full_hp, "HP não diminui sem ataque próximo")
	var bot = combat.spawn_bot(Vector2(385, 300))
	bot.attack_time = 1000.0
	combat.launch_bot_projectile(bot)
	check(arena.inventory.hp == full_hp, "disparo não aplica dano instantâneo")
	var visible_shot := false
	for child in arena.get_children():
		if child is CombatProjectile and not child.from_player:
			visible_shot = true
	check(visible_shot, "ataque do bot cria projétil visível")
	for i in range(10):
		await physics_frame
	check(arena.inventory.hp < full_hp and arena.player.damage_flash > 0.0, "HP diminui apenas no impacto e personagem sinaliza dano")
	var hp_after_hit: int = arena.inventory.hp
	combat.launch_bot_projectile(bot)
	arena.player.position = Vector2(300, 420)
	for i in range(35):
		await physics_frame
	check(arena.inventory.hp == hp_after_hit, "projétil pode ser desviado")
	bot.take_hit(999)
	arena.player.position = Vector2(500, 155)
	var covered_bot = combat.spawn_bot(Vector2(700, 155))
	covered_bot.attack_time = 0.0
	combat.advance(0.016)
	var blocked_shot := false
	for child in arena.get_children():
		if child is CombatProjectile and not child.from_player:
			blocked_shot = true
	check(not blocked_shot, "bot atrás da parede não dispara através da cobertura")
	for i in range(100):
		await physics_frame
	check(arena.inventory.hp == hp_after_hit, "HP permanece estável sem novo impacto")
	arena.queue_free()
	await process_frame
	if failures == 0:
		print("DANO/HP: todos os testes passaram")
	quit(0 if failures == 0 else 1)
