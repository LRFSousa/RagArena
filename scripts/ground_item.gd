extends Node2D
class_name GroundItem

const COLORS := {
	"health_potion": Color("e25b61"),
	"strength": Color("e59143"),
	"speed": Color("69c8f1"),
	"shield": Color("b7a5ef"),
	"elixir": Color("e86caa"),
	"xp_amulet": Color("ecd76e"),
}
const SYMBOLS := {
	"health_potion": "P",
	"strength": "F",
	"speed": "V",
	"shield": "E",
	"elixir": "X",
	"xp_amulet": "A",
}

var item_id := "health_potion"
var remaining := 20.0

func configure(id: String, lifetime: float) -> void:
	item_id = id
	remaining = lifetime
	queue_redraw()

func advance(delta: float) -> void:
	remaining -= maxf(0.0, delta)
	if remaining <= 0.0:
		queue_free()

func _process(delta: float) -> void:
	advance(delta)

func _draw() -> void:
	var color: Color = COLORS.get(item_id, Color.WHITE)
	draw_circle(Vector2.ZERO, 17.0, Color("1c2730"))
	draw_circle(Vector2.ZERO, 14.0, color)
	draw_string(ThemeDB.fallback_font, Vector2(-6, 6), SYMBOLS.get(item_id, "?"), HORIZONTAL_ALIGNMENT_LEFT, -1, 19, Color("182425"))
