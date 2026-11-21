extends Node3D
class_name MountainArena3D

const Probe = preload("res://scripts/experimental/height_attack_probe.gd")
const HEIGHTS := [0.0, 2.5, 5.0]
const RAMP_RISE := 2.5
const RAMP_RUN := 7.0

@onready var actor: MountainTestActor3D = $TestActor
@onready var camera: Camera3D = $TestCamera

var platforms: Array[StaticBody3D] = []
var ramps: Array[StaticBody3D] = []
var rocks: Array[StaticBody3D] = []
var markers: Array[Node3D] = []
var selected_marker := 0
var feedback := ""
var hud: Label
var skill_flash: MeshInstance3D
var flash_time := 0.0

func _ready() -> void:
	build_graybox()
	if camera is MountainTestCamera3D:
		camera.target = actor
		camera.global_position = actor.global_position + camera.camera_offset
		camera.look_at(actor.global_position + Vector3.UP, Vector3.UP)
	elif camera is ArenaOrbitCamera3D:
		camera.target = actor
	build_hud()

func material(color: Color) -> StandardMaterial3D:
	var result := StandardMaterial3D.new()
	result.albedo_color = color
	result.roughness = 1.0
	return result

func block(name: String, center: Vector3, size: Vector3, color: Color, tilt := 0.0) -> StaticBody3D:
	var body := StaticBody3D.new()
	body.name = name
	body.collision_layer = 1
	body.collision_mask = 0
	body.position = center
	body.rotation.x = tilt
	add_child(body)
	var mesh := BoxMesh.new()
	mesh.size = size
	var display := MeshInstance3D.new()
	display.mesh = mesh
	display.material_override = material(color)
	body.add_child(display)
	var collider := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = size
	collider.shape = shape
	body.add_child(collider)
	return body

func rim(name: String, x: float, z: float, width: float, depth: float, top: float) -> void:
	block(name, Vector3(x, top + 0.7, z), Vector3(width, 1.4, depth), Color("575c59"))

func add_ramp(name: String, x: float, z: float, bottom: float, width: float) -> void:
	var angle := atan2(RAMP_RISE, RAMP_RUN)
	var length := sqrt(RAMP_RUN * RAMP_RUN + RAMP_RISE * RAMP_RISE)
	var center := Vector3(x, bottom + RAMP_RISE * 0.5 - 0.16, z)
	ramps.append(block(name, center, Vector3(width, 0.32, length), Color("b39872"), angle))
	for side in [-1.0, 1.0]:
		block(name + "Rail" + str(side), center + Vector3(side * (width * 0.5 + 0.14), 0.58, 0), Vector3(0.28, 1.2, length), Color("555f5d"), angle)

func add_rock(name: String, point: Vector3, radius: float) -> void:
	var body := StaticBody3D.new()
	body.name = name
	body.collision_layer = 1
	body.collision_mask = 0
	body.position = point + Vector3.UP * radius * 0.7
	add_child(body)
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 1.4
	mesh.radial_segments = 8
	mesh.rings = 4
	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	visual.material_override = material(Color("6b7779"))
	body.add_child(visual)
	var shape := SphereShape3D.new()
	shape.radius = radius * 0.8
	var collider := CollisionShape3D.new()
	collider.shape = shape
	body.add_child(collider)
	rocks.append(body)

func marker(name: String, foot: Vector3, color: Color) -> void:
	var node := Node3D.new()
	node.name = name
	node.position = foot
	add_child(node)
	var mesh := SphereMesh.new()
	mesh.radius = 0.28
	mesh.height = 0.56
	var display := MeshInstance3D.new()
	display.mesh = mesh
	display.material_override = material(color)
	display.position.y = 1.0
	node.add_child(display)
	markers.append(node)

func build_graybox() -> void:
	var ground := Color("718765")
	var middle := Color("78966e")
	var summit := Color("89a57b")
	platforms.append(block("LowerPlateau", Vector3(0, -0.2, 16), Vector3(24, 0.4, 12), ground))
	platforms.append(block("MiddlePlateau", Vector3(0, 2.3, -2), Vector3(20, 0.4, 10), middle))
	platforms.append(block("UpperPlateau", Vector3(0, 4.8, -19), Vector3(14, 0.4, 10), summit))
	block("LowerCliff", Vector3(0, -0.7, 16), Vector3(24, 0.6, 12), Color("59665d"))
	block("MiddleCliff", Vector3(0, 0.55, -2), Vector3(20, 3.1, 10), Color("59665d"))
	block("UpperCliff", Vector3(0, 1.8, -19), Vector3(14, 5.6, 10), Color("59665d"))
	add_ramp("LowerRamp", -4.0, 6.5, 0.0, 4.0)
	add_ramp("UpperRamp", 4.0, -10.5, 2.5, 3.2)
	# Bordas têm aberturas apenas nas rampas.
	rim("LowerWest", -12.1, 16, 0.35, 12, 0)
	rim("LowerEast", 12.1, 16, 0.35, 12, 0)
	rim("LowerSouth", 0, 22.1, 24, 0.35, 0)
	rim("LowerNorthLeft", -9, 9.9, 6, 0.35, 0)
	rim("LowerNorthRight", 5, 9.9, 14, 0.35, 0)
	rim("MiddleWest", -10.1, -2, 0.35, 10, 2.5)
	rim("MiddleEast", 10.1, -2, 0.35, 10, 2.5)
	rim("MiddleSouthLeft", -8, 3.1, 4, 0.35, 2.5)
	rim("MiddleSouthRight", 4, 3.1, 12, 0.35, 2.5)
	rim("MiddleNorthLeft", -3.8, -7.1, 12.4, 0.35, 2.5)
	rim("MiddleNorthRight", 7.8, -7.1, 4.4, 0.35, 2.5)
	rim("UpperWest", -7.1, -19, 0.35, 10, 5)
	rim("UpperEast", 7.1, -19, 0.35, 10, 5)
	rim("UpperNorth", 0, -24.1, 14, 0.35, 5)
	rim("UpperSouthLeft", -2.3, -13.9, 9.4, 0.35, 5)
	rim("UpperSouthRight", 6.3, -13.9, 1.4, 0.35, 5)
	# Uma passagem central com 2,6 m separa os blocos de rocha.
	block("NarrowPassageLeft", Vector3(-5.65, 3.15, -2), Vector3(8.7, 1.3, 1.8), Color("656e68"))
	block("NarrowPassageRight", Vector3(5.65, 3.15, -2), Vector3(8.7, 1.3, 1.8), Color("656e68"))
	add_rock("LowerRock", Vector3(5, 0, 15), 1.5)
	add_rock("MiddleRock", Vector3(-7, 2.5, 0), 0.9)
	add_rock("UpperRock", Vector3(-3, 5, -19), 1.2)
	marker("LowerTarget", Vector3(-4, 0, 12.5), Color("d77258"))
	marker("MiddleTarget", Vector3(4, 2.5, -4.5), Color("edc568"))
	marker("UpperTarget", Vector3(4, 5, -18), Color("82cce0"))
	var light := DirectionalLight3D.new()
	light.rotation_degrees = Vector3(-55, -35, 0)
	light.light_energy = 1.4
	add_child(light)
	var environment := WorldEnvironment.new()
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_COLOR
	environment.environment.background_color = Color("b7ccd2")
	environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.environment.ambient_light_color = Color("cbd6cf")
	add_child(environment)
	skill_flash = MeshInstance3D.new()
	var flash_mesh := SphereMesh.new()
	flash_mesh.radius = 0.55
	flash_mesh.height = 1.1
	skill_flash.mesh = flash_mesh
	skill_flash.material_override = material(Color("e6d38a"))
	skill_flash.visible = false
	add_child(skill_flash)

func build_hud() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(20, 20)
	hud.add_theme_font_size_override("font_size", 20)
	hud.add_theme_color_override("font_color", Color.WHITE)
	hud.add_theme_color_override("font_shadow_color", Color.BLACK)
	hud.add_theme_constant_override("shadow_offset_x", 2)
	hud.add_theme_constant_override("shadow_offset_y", 2)
	layer.add_child(hud)

func _process(delta: float) -> void:
	flash_time = maxf(0.0, flash_time - delta)
	if is_instance_valid(skill_flash):
		skill_flash.visible = flash_time > 0.0
	if is_instance_valid(hud):
		hud.text = "ARENA 3D EXPERIMENTAL | WASD mover | C visão geral | 1–3 alvo | Espaço golpe | F efeito\nAltura %.2f m | Alvo %s | %s" % [actor.global_position.y, markers[selected_marker].name, feedback]

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	if event.physical_keycode in [KEY_1, KEY_2, KEY_3]:
		selected_marker = event.physical_keycode - KEY_1
		feedback = "Alvo selecionado"
	elif event.physical_keycode == KEY_C:
		if camera is MountainTestCamera3D:
			camera.overview = not camera.overview
			camera.size = 48.0 if camera.overview else 24.0
			feedback = "Visão geral" if camera.overview else "Visão próxima"
	elif event.physical_keycode == KEY_SPACE or event.physical_keycode == KEY_F:
		var skill: bool = event.physical_keycode == KEY_F
		var result: Dictionary = Probe.inspect(get_world_3d().direct_space_state, actor.global_position, markers[selected_marker].global_position, 4.5 if skill else 3.5, 1.5 if skill else 1.2)
		feedback = ("Efeito" if skill else "Golpe") + ": " + str(result["reason"])
		if skill and result["can_hit"]:
			skill_flash.global_position = markers[selected_marker].global_position + Vector3.UP
			flash_time = 0.35
