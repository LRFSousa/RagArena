extends SceneTree

const MAP_FILE := "res://assets/experimental/ro_reference/mjolnir_01.glb"
const WALK_FILE := "res://assets/experimental/ro_reference/mjolnir_01_nav.gltf"

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	if not ResourceLoader.exists(MAP_FILE) or not ResourceLoader.exists(WALK_FILE):
		print("SKIP: arquivos locais do cliente Ragnarok ausentes")
		quit()
		return
	var scene: Node3D = load("res://scenes/experimental/ragnarok_map_reference.tscn").instantiate()
	root.add_child(scene)
	await physics_frame
	await physics_frame
	assert(scene.has_node("MapaVisualLocal"))
	assert(scene.has_node("ColisaoGAT"))
	assert(scene.actor != null)
	assert(scene.camera != null)
	var body: StaticBody3D = scene.get_node("ColisaoGAT")
	assert(body.get_child(0).shape is ConcavePolygonShape3D)
	for i in range(30):
		await physics_frame
	assert(scene.actor.is_on_floor())
	print("PASS: mapa completo, malha GAT, ator no chão e câmera")
	quit()
