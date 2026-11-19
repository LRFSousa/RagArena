extends SceneTree

const ArenaScene = preload("res://scenes/arena.tscn")
const CrateScene = preload("res://scenes/crate.tscn")
const WallScene = preload("res://scenes/wall.tscn")
const HudScript = preload("res://scripts/arena_hud.gd")
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
	var arena = ArenaScene.instantiate()
	root.add_child(arena)
	await physics_frame
	check(HudScript.MINIMAP_RECT.position.y < 100 and HudScript.MINIMAP_RECT.end.x > 1200, "minimapa no canto superior direito")
	check(not HudScript.MINIMAP_RECT.intersects(Rect2(730, 600, 314, 68)), "minimapa não cobre habilidades")
	arena.player.position = Vector2(1500, 600)
	arena.player.facing = Vector2.RIGHT
	var crates: Array[StaticBody2D] = []
	for x in [1580, 1648, 1740]:
		var crate = CrateScene.instantiate()
		crate.position = Vector2(x, 600)
		arena.add_child(crate)
		crates.append(crate)
	await physics_frame
	check(arena.perform_attack(), "espada encontra caixas no trajeto")
	check(crates[0].hp == 30 and crates[1].hp == 30 and crates[2].hp == 45, "mesmo golpe acerta primeiro e segundo quadro, não o terceiro")
	for crate in crates:
		crate.queue_free()
	await process_frame
	arena.player.position = Vector2(1770, 600)
	arena.combat.select_class("paladin")
	var first = arena.combat.spawn_bot(Vector2(1850, 600))
	var second = arena.combat.spawn_bot(Vector2(1918, 600))
	first.attack_time = 1000.0
	second.attack_time = 1000.0
	await physics_frame
	await physics_frame
	var before_first: int = first.hp
	var before_second: int = second.hp
	arena.perform_attack()
	check(first.hp < before_first and second.hp < before_second, "espada atinge dois oponentes alinhados")
	var wall = WallScene.instantiate()
	wall.position = Vector2(1884, 600)
	wall.size = Vector2(24, 60)
	arena.add_child(wall)
	await physics_frame
	await physics_frame
	before_first = first.hp
	before_second = second.hp
	arena.perform_attack()
	check(first.hp < before_first and second.hp == before_second, "parede entre os quadros protege o alvo de trás")
	arena.queue_free()
	await process_frame
	if failures == 0:
		print("RELEASE 0.7 ALCANCE: todos os testes passaram")
	quit(0 if failures == 0 else 1)
