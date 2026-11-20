extends SceneTree

const Layout = preload("res://scripts/arena_map_layout.gd")
const ArenaScene = preload("res://scenes/arena.tscn")

func _initialize() -> void:
	call_deferred("run_test")

func run_test() -> void:
	assert(Layout.WORLD_SIZE == Vector2(2560, 1440))
	assert(Layout.SPAWNS.size() == 5)
	assert(Layout.WALLS.size() == 17)
	assert(Layout.CRATES.size() == 24)
	assert(Layout.ground_to_3d(Vector2(410, 176), 3.0) == Vector3(410, 3, 176))
	assert(Layout.footprint_to_3d(Layout.CRATE_SIZE, 48.0) == Vector3(68, 48, 68))
	var arena = ArenaScene.instantiate()
	root.add_child(arena)
	await physics_frame
	assert(arena.player.position == Layout.SPAWNS[0])
	assert(arena.ARENA == Layout.PLAYABLE_RECT)
	assert(arena.wooden_blocks == Layout.CRATES.size())
	assert(arena.match_controller.FULL_ARENA == Layout.PLAYABLE_RECT)
	arena.queue_free()
	await process_frame
	print("MAP LAYOUT: dimensões, spawns, obstáculos e projeção 3D passaram")
	quit(0)
