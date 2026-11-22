extends SceneTree

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var map: Node3D = load("res://scenes/VesperaMap.tscn").instantiate()
	root.add_child(map)
	assert((map.get_node("Piso") as CSGBox3D).size == Vector3(160, 1, 160))
	assert(map.get_node("MuroCidade").get_child_count() > 50)
	var gate_material := _first_mesh(map.get_node("MuroCidade/Portão Principal")).get_active_material(0) as ShaderMaterial
	var tower_material := _first_mesh(map.get_node("MuroCidade/Torre2")).get_active_material(0) as ShaderMaterial
	var broken_material := _first_mesh(map.get_node("MuroCidade/Mural de Castelo Quebrado2")).get_active_material(0) as ShaderMaterial
	assert(gate_material.get_shader_parameter("stone_gain") > 1.0 and tower_material.get_shader_parameter("stone_gain") < 1.0)
	assert(broken_material.get_shader_parameter("moss_gain") < 1.0)
	assert(gate_material.get_shader_parameter("base_color_map") != null and tower_material.get_shader_parameter("normal_map") != null and broken_material.get_shader_parameter("rm_map") != null)
	var scene: Arena01Playtest = load("res://scenes/VesperaPlaytest.tscn").instantiate()
	root.add_child(scene)
	for i in range(4):
		await physics_frame
	assert(scene.use_vespera_map and scene.actor != null and scene.camera != null and scene.controls != null)
	assert(scene.actor.model_3d != null and scene.actor.walk_model_3d != null and scene.actor.model_3d.visible)
	assert(scene.actor.global_position == Vector3(0, 0, 42))
	assert(scene.markers.size() == 3 and scene.map_bounds == Rect2(-80, -80, 160, 160))
	assert(scene.actor.ramp_passages.size() == 1)
	assert(map.get_node("Cidade/TerracoIgreja") != null)
	assert(map.get_node("Cidade/ObstaculosCidade").get_child_count() >= 9)
	var space := scene.get_world_3d().direct_space_state
	var center := space.intersect_ray(PhysicsRayQueryParameters3D.create(Vector3(0, 2, 0), Vector3(0, -2, 0), 1))
	assert(not center.is_empty() and absf(center.position.y) < 0.2)
	for point in [Vector2(-79, 0), Vector2(79, 0), Vector2(0, -79), Vector2(0, 79)]:
		var boundary := space.intersect_ray(PhysicsRayQueryParameters3D.create(Vector3.ZERO, Vector3(point.x, 1, point.y), 1))
		assert(not boundary.is_empty(), "Muralha precisa bloquear a borda %s" % point)
	print("vespera_smoke: OK")
	quit()

func _first_mesh(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var mesh := _first_mesh(child)
		if mesh != null:
			return mesh
	return null
