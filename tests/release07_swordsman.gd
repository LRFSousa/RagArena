extends SceneTree

const PlayerScene = preload("res://scenes/player.tscn")
const DIRECTIONS := ["right", "left", "up", "down"]
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
	for direction in DIRECTIONS:
		var path := "res://assets/characters/swordsman/ragnarena_espachim_walk_%s.png" % direction
		var texture: Texture2D = load(path)
		check(texture != null and texture.get_size() == Vector2(1536, 256), "%s: seis quadros de 256 px" % direction)
		check(texture.get_image().get_pixel(0, 0).a == 0.0, "%s: transparência preservada" % direction)
	var player = PlayerScene.instantiate()
	root.add_child(player)
	await process_frame
	check(player.visual_class == "paladin" and player.visual_sprite.hframes == 6 and player.visual_sprite.vframes == 1 and player.visual_sprite.scale == Vector2(0.25, 0.25), "Espadachim substitui visual provisório do Paladino")
	for direction in DIRECTIONS:
		var vector := Vector2.RIGHT if direction == "right" else Vector2.LEFT if direction == "left" else Vector2.UP if direction == "up" else Vector2.DOWN
		player.facing = vector
		player.move_input = vector
		player._physics_process(0.16)
		check(player.visual_direction == direction and player.visual_sprite.texture.resource_path.ends_with("walk_%s.png" % direction), "animação aponta para %s" % direction)
	player.move_input = Vector2.ZERO
	player._physics_process(0.016)
	check(player.visual_sprite.frame == 0, "parado usa primeiro quadro")
	player.set_visual_class("mage")
	check(player.visual_sprite.hframes == 4 and player.visual_sprite.vframes == 5 and player.visual_sprite.scale == Vector2.ONE, "outras classes mantêm sprites existentes")
	player.queue_free()
	await process_frame
	if failures == 0:
		print("RELEASE 0.7 ESPADACHIM: todos os testes passaram")
	quit(0 if failures == 0 else 1)
