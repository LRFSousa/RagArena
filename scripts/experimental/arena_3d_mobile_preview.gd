extends MountainArena3D

const Controls = preload("res://scripts/experimental/mobile_arena_controls_3d.gd")

var controls: Control
var target_hp := [100, 100, 100]
var hits_landed := 0
var player_hp := 75
var shield_time := 0.0
var determination_time := 0.0
var attack_cooldown := 0.0
var skill_cooldowns := [0.0, 0.0, 0.0]
var potions := [3, 2, 1]

func _ready() -> void:
	super._ready()
	actor.accept_player_input = false
	actor.movement_camera = camera
	camera.distance = 27.0
	var layer := CanvasLayer.new()
	layer.name = "MobileControls"
	add_child(layer)
	controls = Controls.new()
	layer.add_child(controls)
	controls.action_pressed.connect(_on_action)
	controls.arena = self
	feedback = "Aproxime-se do alvo e toque em ATK"

func _physics_process(delta: float) -> void:
	if controls != null:
		actor.move_input = (Input.get_vector("move_left", "move_right", "move_up", "move_down") + controls.movement).limit_length(1.0)
	attack_cooldown = maxf(attack_cooldown - delta, 0.0)
	for i in range(skill_cooldowns.size()):
		skill_cooldowns[i] = maxf(skill_cooldowns[i] - delta, 0.0)
	shield_time = maxf(shield_time - delta, 0.0)
	determination_time = maxf(determination_time - delta, 0.0)
	controls.queue_redraw()

func _process(delta: float) -> void:
	super._process(delta)
	if hud != null:
		hud.text = "HP %d/100 | Alvo %d: %d HP | Acertos %d\n%s" % [player_hp, selected_marker + 1, target_hp[selected_marker], hits_landed, feedback]

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_1, KEY_2, KEY_3:
				selected_marker = event.physical_keycode - KEY_1
				feedback = "Alvo %d selecionado" % (selected_marker + 1)
				return
			KEY_SPACE:
				_on_action("ATK")
				return
			KEY_Q:
				_on_action("ESC")
				return
			KEY_E:
				_on_action("CURA")
				return
			KEY_F:
				_on_action("FOR")
				return
			KEY_C:
				camera.zoom_by_steps(-1.0)
				return
	super._unhandled_input(event)

func _on_action(action: String) -> void:
	match action:
		"ALVO":
			selected_marker = (selected_marker + 1) % markers.size()
			feedback = "Alvo %d selecionado" % (selected_marker + 1)
		"ATK":
			_attack_selected()
		"ESC":
			if skill_cooldowns[0] > 0.0:
				return
			skill_cooldowns[0] = 12.0
			shield_time = 10.0
			_show_effect(actor.global_position + Vector3.UP, Color(1.0, 0.72, 0.16, 0.55))
			feedback = "Proteção ativa por 10 s"
		"CURA":
			if skill_cooldowns[1] > 0.0:
				return
			skill_cooldowns[1] = 8.0
			player_hp = mini(100, player_hp + 25)
			_show_effect(actor.global_position + Vector3.UP, Color(0.2, 1.0, 0.35, 0.55))
			feedback = "Cura: HP %d/100" % player_hp
		"FOR":
			if skill_cooldowns[2] > 0.0:
				return
			skill_cooldowns[2] = 15.0
			determination_time = 10.0
			_show_effect(actor.global_position + Vector3.UP, Color(1.0, 0.56, 0.09, 0.6))
			feedback = "Determinação: dano +10 por 10 s"
		"POT_HP":
			if potions[0] > 0 and player_hp < 100:
				potions[0] -= 1
				player_hp = mini(100, player_hp + 40)
				feedback = "Poção de HP: %d/100" % player_hp
		"POT_ELIXIR":
			if potions[1] > 0:
				potions[1] -= 1
				player_hp = mini(100, player_hp + 25)
				feedback = "Elixir: %d/100" % player_hp
		"POT_STRENGTH":
			if potions[2] > 0:
				potions[2] -= 1
				determination_time = 10.0
				feedback = "Poção de força ativa"

func _attack_selected() -> void:
	if attack_cooldown > 0.0:
		return
	attack_cooldown = 0.75
	actor.start_attack_preview()
	var result: Dictionary = Probe.inspect(get_world_3d().direct_space_state, actor.global_position, markers[selected_marker].global_position)
	if not result["can_hit"]:
		feedback = "Golpe sem acerto: %s" % str(result["reason"])
		return
	var damage := 20 + (10 if determination_time > 0.0 else 0)
	target_hp[selected_marker] -= damage
	hits_landed += 1
	_show_effect(markers[selected_marker].global_position + Vector3.UP, Color(1.0, 0.78, 0.22, 0.7))
	if target_hp[selected_marker] <= 0:
		feedback = "Alvo %d derrotado; treino reiniciado" % (selected_marker + 1)
		target_hp[selected_marker] = 100
	else:
		feedback = "Golpe: %d de dano no alvo %d" % [damage, selected_marker + 1]

func _show_effect(point: Vector3, color: Color) -> void:
	skill_flash.global_position = point
	skill_flash.material_override = material(color)
	flash_time = 0.45
