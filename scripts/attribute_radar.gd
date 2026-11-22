extends Control
class_name AttributeRadar

const KEYS := ["for", "agi", "vit", "int", "des", "sor"]
const LABELS := ["FOR", "AGI", "VIT", "INT", "DES", "SOR"]
var values: Array[float] = [5.0, 5.0, 5.0, 5.0, 5.0, 5.0]

func _ready() -> void:
	custom_minimum_size = Vector2(300, 200)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func set_character(character: Dictionary) -> void:
	values.clear()
	for key in KEYS:
		values.append(float(ArenaAttributes.effective_value(character, key)))
	queue_redraw()

func _draw() -> void:
	var center := size * Vector2(0.5, 0.52)
	var radius := minf(size.x * 0.28, size.y * 0.35)
	var gold := Color("d9ad62")
	for fraction in [0.33, 0.66, 1.0]:
		var ring := PackedVector2Array()
		for i in range(6): ring.append(_point(center, radius * fraction, i))
		draw_polyline(ring + PackedVector2Array([ring[0]]), Color("94775088"), 1.5)
	for i in range(6): draw_line(center, _point(center, radius, i), Color("94775088"), 1.0)
	var fill := PackedVector2Array()
	for i in range(6): fill.append(_point(center, radius * clampf(values[i] / 99.0, 0.12, 1.0), i))
	draw_colored_polygon(fill, Color("d9ad6280"))
	draw_polyline(fill + PackedVector2Array([fill[0]]), gold, 2.5)
	for i in range(6):
		draw_circle(fill[i], 3.5, Color("ffe2a0"))
		var point := _point(center, radius + 17.0, i)
		draw_string(ThemeDB.fallback_font, point + Vector2(-14, 5), LABELS[i], HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color("f5ead2"))

func _point(center: Vector2, radius: float, index: int) -> Vector2:
	var angle := -PI / 2.0 + TAU * float(index) / 6.0
	return center + Vector2(cos(angle), sin(angle)) * radius
