extends Node3D
class_name Arena01Playtest

const Probe = preload("res://scripts/experimental/height_attack_probe.gd")
const Controls = preload("res://scripts/experimental/mobile_arena_controls_3d.gd")
const OrbitCamera = preload("res://scripts/experimental/orbit_camera_3d.gd")

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
var map_bounds := Rect2(-40, -40, 80, 80)
var map_regions: Array[Rect2] = [Rect2(-40, -40, 80, 80), Rect2(-32, -32, 24, 24), Rect2(11, 11.7, 24, 24)]
var effect: MeshInstance3D
var effect_time := 0.0

func _ready() -> void:
	_configure_geometry()
	actor.accept_player_input = false
	actor.use_3d_model = true
	actor.guard_walkable_edges = true
	actor.ramp_passages = [Rect2(-8, -31, 10, 4), Rect2(1, 30.7, 10, 4)]
	camera = OrbitCamera.new()
	camera.name = "ArenaCamera"
	camera.distance = 34.0
	camera.min_distance = 12.0
	camera.max_distance = 78.0
	add_child(camera)
	camera.target = actor
	camera.current = true
	actor.movement_camera = camera
	_create_target("AlvoPiso", Vector3(0, 0, -11), Color("d77258"))
	_create_target("AlvoMorroOeste", Vector3(-20, 5, -20), Color("edc568"))
	_create_target("AlvoMorroLeste", Vector3(23, 5, 23.7), Color("82cce0"))
	var layer := CanvasLayer.new()
	add_child(layer)
	controls = Controls.new()
	controls.arena = self
	layer.add_child(controls)
	controls.action_pressed.connect(_on_action)
	hud = Label.new()
	hud.position = Vector2(20, 20)
	hud.add_theme_font_size_override("font_size", 20)
	hud.add_theme_color_override("font_color", Color.WHITE)
	hud.add_theme_color_override("font_shadow_color", Color.BLACK)
	hud.add_theme_constant_override("shadow_offset_x", 2)
	hud.add_theme_constant_override("shadow_offset_y", 2)
	layer.add_child(hud)
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
	_add_boundary("FechamentoNorte", Vector3(0, 2, -39.5))
	_add_boundary("FechamentoSul", Vector3(0, 2, 39.5))

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
		actor.move_input = (Input.get_vector("move_left", "move_right", "move_up", "move_down") + controls.movement).limit_length(1)
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
	if actor.model_3d != null:
		actor.model_3d.rotation.y = atan2(delta.x, delta.z)
	actor.start_attack_preview()
	var result: Dictionary = Probe.inspect(get_world_3d().direct_space_state, actor.global_position, target.global_position)
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
