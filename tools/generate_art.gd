extends SceneTree

# Fonte reproduzível dos sprites provisórios da release 0.7.
# Atlas de cada classe: 4 quadros por 5 linhas (idle, caminhada, ataque, dano, morte).
const CLASSES := {
	"paladin": [Color("d6b86c"), Color("e9e2ce"), Color("536b93")],
	"mage": [Color("8267bd"), Color("bde3ef"), Color("e9b764")],
	"assassin": [Color("4b806f"), Color("222f3b"), Color("e06878")],
	"archer": [Color("a57648"), Color("a7ca78"), Color("e1d1a1")],
}

func _initialize() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path("res://assets/pixel"))
	for id in CLASSES:
		var image := Image.create(256, 320, false, Image.FORMAT_RGBA8)
		image.fill(Color.TRANSPARENT)
		for row in range(5):
			for frame in range(4):
				draw_character(image, id, row, frame)
		image.save_png("res://assets/pixel/%s.png" % id)
	for kind in ["crate", "wall"]:
		var tile := Image.create(32, 32, false, Image.FORMAT_RGBA8)
		tile.fill(Color.TRANSPARENT)
		draw_tile(tile, kind)
		tile.save_png("res://assets/pixel/%s.png" % kind)
	for id in ["health_potion", "strength", "speed", "shield", "elixir", "xp_amulet"]:
		var icon := Image.create(16, 16, false, Image.FORMAT_RGBA8)
		icon.fill(Color.TRANSPARENT)
		draw_item(icon, id)
		icon.save_png("res://assets/pixel/%s.png" % id)
	quit()

func block(image: Image, x: int, y: int, w: int, h: int, color: Color, scale: int = 4, origin: Vector2i = Vector2i.ZERO) -> void:
	image.fill_rect(Rect2i(origin + Vector2i(x, y) * scale, Vector2i(w, h) * scale), color)

func draw_character(image: Image, id: String, row: int, frame: int) -> void:
	var origin := Vector2i(frame * 64, row * 64)
	var colors: Array = CLASSES[id]
	var main: Color = colors[0]
	var trim: Color = colors[1]
	var accent: Color = colors[2]
	var outline := Color("202833")
	var skin := Color("e8b890")
	var step := (frame % 2) if row == 1 else 0
	var lean := 2 if row == 4 else 0
	# Sombra, botas, torso, braços e rosto sobre uma malha de 16x16 pixels.
	block(image, 4, 14, 9, 1, Color("18242b83"), 4, origin)
	block(image, 5 + lean, 11 + step, 2, 3 - step, outline, 4, origin)
	block(image, 9 + lean, 11 + (1 - step if row == 1 else 0), 2, 3, outline, 4, origin)
	block(image, 4 + lean, 7, 8, 5, outline, 4, origin)
	block(image, 5 + lean, 7, 6, 4, main if row != 3 else Color("f07875"), 4, origin)
	block(image, 6 + lean, 3, 4, 4, outline, 4, origin)
	block(image, 7 + lean, 4, 2, 2, skin, 4, origin)
	block(image, 4 + lean, 7, 1, 4, trim, 4, origin)
	block(image, 11 + lean, 7 - (2 if row == 2 and frame % 2 else 0), 1, 4, trim, 4, origin)
	if id == "paladin":
		block(image, 5 + lean, 2, 6, 2, trim, 4, origin)
		block(image, 6 + lean, 8, 4, 2, accent, 4, origin)
		block(image, 2 + lean, 7, 2, 4, accent, 4, origin) # escudo
	elif id == "mage":
		block(image, 4 + lean, 2, 8, 2, main, 4, origin)
		block(image, 7 + lean, 0, 3, 2, main, 4, origin)
		block(image, 6 + lean, 8, 4, 1, accent, 4, origin)
		block(image, 12 + lean, 5, 1, 7, accent, 4, origin) # cajado
	elif id == "assassin":
		block(image, 5 + lean, 2, 6, 3, accent, 4, origin)
		block(image, 7 + lean, 5, 2, 1, trim, 4, origin)
		block(image, 12 + lean, 9, 2, 1, Color("d9e4e2"), 4, origin)
	elif id == "archer":
		block(image, 5 + lean, 2, 6, 2, accent, 4, origin)
		block(image, 6 + lean, 8, 4, 2, trim, 4, origin)
		block(image, 12 + lean, 5, 1, 8, accent, 4, origin) # arco
	if row == 4:
		block(image, 3, 12, 10, 2, Color("263541"), 4, origin)

func draw_tile(image: Image, kind: String) -> void:
	var dark := Color("543b2d") if kind == "crate" else Color("384652")
	var main := Color("a46d41") if kind == "crate" else Color("697985")
	var light := Color("dc9b58") if kind == "crate" else Color("a5b3b5")
	image.fill(dark)
	image.fill_rect(Rect2i(2, 2, 28, 28), main)
	image.fill_rect(Rect2i(4, 4, 24, 4), light)
	if kind == "crate":
		image.fill_rect(Rect2i(6, 6, 3, 20), dark)
		image.fill_rect(Rect2i(23, 6, 3, 20), dark)
		image.fill_rect(Rect2i(4, 14, 24, 3), dark)
	else:
		image.fill_rect(Rect2i(4, 15, 24, 2), dark)
		image.fill_rect(Rect2i(15, 3, 2, 12), dark)
		image.fill_rect(Rect2i(9, 17, 2, 11), dark)

func draw_item(image: Image, id: String) -> void:
	var colors := {"health_potion": Color("f06c79"), "strength": Color("eda75c"), "speed": Color("70d4e9"), "shield": Color("baaeed"), "elixir": Color("eb80c3"), "xp_amulet": Color("f4df78")}
	var color: Color = colors[id]
	image.fill_rect(Rect2i(3, 3, 10, 11), Color("263541"))
	image.fill_rect(Rect2i(5, 1, 6, 3), Color("dce5dc"))
	image.fill_rect(Rect2i(4, 5, 8, 8), color)
	image.fill_rect(Rect2i(5, 6, 2, 5), Color("ffffff88"))
