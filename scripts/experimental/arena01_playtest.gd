extends Node3D
class_name Arena01Playtest

const Probe = preload("res://scripts/experimental/height_attack_probe.gd")
const Controls = preload("res://scripts/experimental/mobile_arena_controls_3d.gd")
const OrbitCamera = preload("res://scripts/experimental/orbit_camera_3d.gd")
const ProfileStore = preload("res://scripts/local_profile_store.gd")
const AttributePanel = preload("res://scripts/attribute_window.gd")

@onready var actor: MountainTestActor3D = $TestActor3D

var camera: ArenaOrbitCamera3D
var controls: MobileArenaControls3D
var hud: Label
var markers: Array[Node3D] = []
var selected_marker := 0
var target_hp := [100, 100, 100]
var player_hp := 75
var hits_landed := 0
var shield_time := 0.0
var determination_time := 0.0
var attack_cooldown := 0.0
var skill_cooldowns := [0.0, 0.0, 0.0]
var potions := [3, 2, 1]
var feedback := "Aproxime-se de um alvo e toque em ATK"
var map_bounds := Rect2(-80, -80, 160, 160)
var map_regions: Array[Rect2] = [Rect2(-80, -80, 160, 160), Rect2(-60, -60, 24, 24), Rect2(36, 36, 24, 24)]
var effect: MeshInstance3D
var effect_time := 0.0
var profile_store: LocalProfileStore
var attribute_window: AttributeWindow
var ui_layer: CanvasLayer

func _ready() -> void:
	_configure_geometry()
	actor.accept_player_input = false
	actor.speed = 8.0
	actor.use_3d_model = true
	actor.guard_walkable_edges = true
	actor.ramp_passages = [Rect2(-54, -36, 4, 10), Rect2(-36, -59, 10, 4), Rect2(50, 26, 4, 10), Rect2(26, 55, 10, 4)]
	actor.face_world_direction(Vector3(0, 0, -1))
	camera = OrbitCamera.new()
	camera.name = "ArenaCamera"
	camera.distance = 34.0
	camera.min_distance = 12.0
	camera.max_distance = 420.0
	camera.overview_blend_start = 80.0
	camera.overview_blend_end = 420.0
	add_child(camera)
	camera.target = actor
	camera.current = true
	actor.movement_camera = camera
	_create_target("AlvoPiso", Vector3(0, 0, -21), Color("d77258"))
	_create_target("AlvoMorroOeste", Vector3(-48, 5, -48), Color("edc568"))
	_create_target("AlvoMorroLeste", Vector3(48, 5, 48), Color("82cce0"))
	ui_layer = CanvasLayer.new()
	add_child(ui_layer)
	controls = Controls.new()
	controls.arena = self
	ui_layer.add_child(controls)
	controls.action_pressed.connect(_on_action)
	var attributes_button := Button.new()
	attributes_button.text = "Atributos"
	attributes_button.position = Vector2(20, 92)
	attributes_button.size = Vector2(145, 43)
	attributes_button.custom_minimum_size = Vector2(145, 43)
	attributes_button.pressed.connect(show_attributes)
	ui_layer.add_child(attributes_button)
	var exp_button := Button.new()
	exp_button.text = "EXP teste"
	exp_button.position = Vector2(175, 92)
	exp_button.size = Vector2(145, 43)
	exp_button.custom_minimum_size = Vector2(145, 43)
	exp_button.pressed.connect(_grant_test_exp)
	ui_layer.add_child(exp_button)
	hud = Label.new()
	hud.position = Vector2(20, 20)
	hud.add_theme_font_size_override("font_size", 20)
	hud.add_theme_color_override("font_color", Color.WHITE)
	hud.add_theme_color_override("font_shadow_color", Color.BLACK)
	hud.add_theme_constant_override("shadow_offset_x", 2)
	hud.add_theme_constant_override("shadow_offset_y", 2)
	ui_layer.add_child(hud)
	effect = MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.65
	sphere.height = 1.3
	effect.mesh = sphere
	effect.visible = false
	add_child(effect)

func _configure_geometry() -> void:
	for child in get_children():
		if not child is CSGShape3D:
			continue
		var shape: CSGShape3D = child
		shape.use_collision = true
		shape.collision_layer = 1
		var color := Color("829e75")
		if child.name.begins_with("Rampa"):
			color = Color("c9aa76")
		elif child.name.begins_with("Morro"):
			color = Color("6f896b")
		elif child.name.begins_with("Muro") or child.name.begins_with("Ruina"):
			color = Color("727d78")
		elif child.name.begins_with("Rocha"):
			color = Color("677377")
		elif child.name.begins_with("Cerca"):
			color = Color("a68562")
		var mat := StandardMaterial3D.new()
		mat.albedo_color = color
		shape.material_override = mat
	var sunlight := DirectionalLight3D.new()
	sunlight.rotation_degrees = Vector3(-55, -30, 0)
	sunlight.light_energy = 1.4
	add_child(sunlight)
	var world := WorldEnvironment.new()
	world.environment = Environment.new()
	world.environment.background_mode = Environment.BG_COLOR
	world.environment.background_color = Color("b7ccd2")
	world.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	world.environment.ambient_light_color = Color("d0d8d1")
	add_child(world)
	# A cena recebida deixa aberturas de 8 m nas bordas norte e sul.
	# Fecha-se apenas a versão jogável; o desenho original permanece como referência.
	_add_boundary("FechamentoNorte", Vector3(0, 2, -79.5))
	_add_boundary("FechamentoSul", Vector3(0, 2, 79.5))
	_add_ramp_collider("RampaOestePiso", Vector3(-52, 2.3, -31), 1.0)
	_add_ramp_collider("RampaOeste2Piso", Vector3(52, 2.3, 31), -1.0)
	# Bordas funcionais impedem que o personagem escape pela lateral no meio da subida.
	_add_ramp_rails("RampaOeste", Vector3(-52, 2.9, -31), Vector3(1, 0, 0), 1.0)
	_add_ramp_rails("RampaLeste", Vector3(-31, 2.9, -57), Vector3(0, 0, 1), -1.0)
	_add_ramp_rails("RampaOeste2", Vector3(52, 2.9, 31), Vector3(1, 0, 0), -1.0)
	_add_ramp_rails("RampaLeste2", Vector3(31, 2.9, 57), Vector3(0, 0, 1), 1.0)

func _add_ramp_rails(ramp_name: String, center: Vector3, lateral: Vector3, slope_sign: float) -> void:
	for side in [-1.0, 1.0]:
		var rail := StaticBody3D.new()
		rail.name = "%sBorda%s" % [ramp_name, "A" if side < 0 else "B"]
		rail.collision_layer = 1
		rail.position = center + lateral * (side * 2.05)
		if lateral.x != 0:
			rail.rotation.x = slope_sign * atan2(5.0, 10.0)
		else:
			rail.rotation.z = slope_sign * atan2(5.0, 10.0)
		add_child(rail)
		var shape := BoxShape3D.new()
		shape.size = Vector3(0.3, 1.1, sqrt(125.0)) if lateral.x != 0 else Vector3(sqrt(125.0), 1.1, 0.3)
		var collider := CollisionShape3D.new()
		collider.shape = shape
		rail.add_child(collider)
		var display := MeshInstance3D.new()
		var mesh := BoxMesh.new()
		mesh.size = shape.size
		display.mesh = mesh
		var material := StandardMaterial3D.new()
		material.albedo_color = Color("b79765")
		display.material_override = material
		rail.add_child(display)

func _add_ramp_collider(collider_name: String, center: Vector3, slope_sign: float) -> void:
	var body := StaticBody3D.new()
	body.name = collider_name
	body.collision_layer = 1
	body.position = center
	body.rotation.x = slope_sign * atan2(5.0, 10.0)
	add_child(body)
	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = Vector3(4, 0.3, sqrt(125.0))
	collider.shape = shape
	body.add_child(collider)

func _add_boundary(boundary_name: String, point: Vector3) -> void:
	var body := StaticBody3D.new()
	body.name = boundary_name
	body.collision_layer = 1
	body.position = point
	add_child(body)
	var box := BoxMesh.new()
	box.size = Vector3(8, 4, 1)
	var display := MeshInstance3D.new()
	display.mesh = box
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color("727d78")
	display.material_override = mat
	body.add_child(display)
	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = box.size
	collider.shape = shape
	body.add_child(collider)

func _create_target(target_name: String, foot: Vector3, color: Color) -> void:
	var target := Node3D.new()
	target.name = target_name
	target.position = foot
	add_child(target)
	var mesh := MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.4
	sphere.height = 0.8
	mesh.mesh = sphere
	mesh.position.y = 1.0
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mesh.material_override = mat
	target.add_child(mesh)
	markers.append(target)

func _physics_process(delta: float) -> void:
	if controls != null:
		actor.move_input = Vector2.ZERO if is_instance_valid(attribute_window) else (Input.get_vector("move_left", "move_right", "move_up", "move_down") + controls.movement).limit_length(1)
	attack_cooldown = maxf(0, attack_cooldown - delta)
	shield_time = maxf(0, shield_time - delta)
	determination_time = maxf(0, determination_time - delta)
	effect_time = maxf(0, effect_time - delta)
	effect.visible = effect_time > 0
	for i in range(skill_cooldowns.size()):
		skill_cooldowns[i] = maxf(0, skill_cooldowns[i] - delta)
	if controls != null:
		controls.queue_redraw()

func _process(_delta: float) -> void:
	if hud != null:
		hud.text = "ARENA 01 | HP %d/100 | Alvo %d: %d HP | Acertos %d\n%s" % [player_hp, selected_marker + 1, target_hp[selected_marker], hits_landed, feedback]

func _unhandled_input(event: InputEvent) -> void:
	if is_instance_valid(attribute_window):
		return
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	match event.physical_keycode:
		KEY_1, KEY_2, KEY_3:
			selected_marker = event.physical_keycode - KEY_1
		KEY_SPACE:
			_on_action("ATK")
		KEY_Q:
			_on_action("ESC")
		KEY_E:
			_on_action("CURA")
		KEY_F:
			_on_action("FOR")
		KEY_C:
			show_attributes()

func _ensure_test_character() -> String:
	if profile_store == null:
		profile_store = ProfileStore.new()
	if not profile_store.has_identity() and not profile_store.create_identity("Jogador"):
		feedback = profile_store.last_error
		return ""
	var selected := profile_store.find_character(str(profile_store.data["selected_character_id"]))
	if not selected.is_empty() and str(selected["class_id"]) == "swordsman":
		return str(selected["id"])
	for character in profile_store.data["characters"]:
		if str(character.get("class_id", "")) == "swordsman":
			profile_store.select_character(str(character["id"]))
			return str(character["id"])
	var id := profile_store.create_character("Espadachim", "swordsman")
	if id == "":
		feedback = "Crie um Espadachim no menu de personagens: %s" % profile_store.last_error
		return ""
	profile_store.select_character(id)
	return id

func show_attributes() -> void:
	var id := _ensure_test_character()
	if id == "" or is_instance_valid(attribute_window):
		return
	controls.movement = Vector2.ZERO
	attribute_window = AttributePanel.new()
	attribute_window.store = profile_store
	attribute_window.character_id = id
	attribute_window.derived_stats = {"HP": 100, "ATQ": 20, "Velocidade": actor.speed, "Alcance": "2 blocos"}
	ui_layer.add_child(attribute_window)
	attribute_window.closed.connect(func():
		attribute_window.queue_free()
		attribute_window = null)

func _grant_test_exp() -> void:
	var id := _ensure_test_character()
	if id == "":
		return
	var match_id := "teste-" + Crypto.new().generate_random_bytes(16).hex_encode()
	var reward := profile_store.settle_match(id, {"match_id": match_id, "active_seconds": 480.0, "arena_limit_seconds": 480.0, "kills": 5, "assists": 5, "effective_skills": 5, "completed_with_winner": true, "won": true})
	if reward.is_empty():
		feedback = profile_store.last_error
		return
	var character := profile_store.find_character(id)
	feedback = "EXP teste: Base +%d, Job +%d | Base %d, Job %d | Pontos +%d/+%d" % [reward["base_awarded"], reward["job_awarded"], character["base_level"], character["job_level"], reward["attribute_points_awarded"], reward["skill_points_awarded"]]
	if is_instance_valid(attribute_window):
		attribute_window.refresh()

func _on_action(action: String) -> void:
	match action:
		"ALVO":
			selected_marker = (selected_marker + 1) % markers.size()
			feedback = "Alvo %d selecionado" % (selected_marker + 1)
		"ATK":
			_attack_selected()
		"ESC":
			if skill_cooldowns[0] <= 0:
				skill_cooldowns[0] = 12
				shield_time = 10
				_show_effect(actor.global_position + Vector3.UP, Color("ffd861aa"))
				feedback = "Proteção ativa por 10 s"
		"CURA":
			if skill_cooldowns[1] <= 0:
				skill_cooldowns[1] = 8
				player_hp = mini(100, player_hp + 25)
				_show_effect(actor.global_position + Vector3.UP, Color("50ff80aa"))
				feedback = "Cura: %d/100 HP" % player_hp
		"FOR":
			if skill_cooldowns[2] <= 0:
				skill_cooldowns[2] = 15
				determination_time = 10
				_show_effect(actor.global_position + Vector3.UP, Color("ffae39aa"))
				feedback = "Determinação ativa por 10 s"
		"POT_HP":
			if potions[0] > 0 and player_hp < 100:
				potions[0] -= 1
				player_hp = mini(100, player_hp + 40)
		"POT_ELIXIR":
			if potions[1] > 0:
				potions[1] -= 1
				player_hp = mini(100, player_hp + 25)
		"POT_STRENGTH":
			if potions[2] > 0:
				potions[2] -= 1
				determination_time = 10

func _attack_selected() -> void:
	if attack_cooldown > 0:
		return
	attack_cooldown = 0.75
	var target := markers[selected_marker]
	var delta := target.global_position - actor.global_position
	var toward_target := Vector3(delta.x, 0, delta.z).normalized()
	var result: Dictionary = Probe.inspect(get_world_3d().direct_space_state, actor.global_position, target.global_position)
	if result["can_hit"] and actor.facing_world.dot(toward_target) < 0.7:
		actor.face_world_direction(toward_target)
	actor.start_attack_preview()
	if not result["can_hit"]:
		feedback = "Sem acerto: %s" % result["reason"]
		return
	var damage := 20 + (10 if determination_time > 0 else 0)
	target_hp[selected_marker] -= damage
	hits_landed += 1
	_show_effect(target.global_position + Vector3.UP, Color("ffd568bb"))
	if target_hp[selected_marker] <= 0:
		target_hp[selected_marker] = 100
		feedback = "Alvo %d derrotado; treino reiniciado" % (selected_marker + 1)
	else:
		feedback = "Golpe: %d de dano no alvo %d" % [damage, selected_marker + 1]

func _show_effect(point: Vector3, color: Color) -> void:
	effect.global_position = point
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	effect.material_override = mat
	effect_time = 0.45
