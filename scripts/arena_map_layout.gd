extends RefCounted
class_name ArenaMapLayout

# Coordenadas lógicas do chão. X/Y em 2D correspondem a X/Z em 3D.
# Uma unidade lógica equivale a uma unidade de mundo; altura fica no eixo Y 3D.
const WORLD_SIZE := Vector2(2560, 1440)
const PLAYABLE_RECT := Rect2(52, 52, 2456, 1336)
const SPAWNS := [
	Vector2(150, 150), Vector2(2350, 150),
	Vector2(150, 1290), Vector2(2350, 1290), Vector2(1280, 720)
]
const WALLS := [
	[Vector2(1280, 36), Vector2(2496, 32)],
	[Vector2(1280, 1404), Vector2(2496, 32)],
	[Vector2(36, 720), Vector2(32, 1368)],
	[Vector2(2524, 720), Vector2(32, 1368)],
	[Vector2(275, 180), Vector2(75, 52)],
	[Vector2(1005, 180), Vector2(75, 52)],
	[Vector2(275, 540), Vector2(75, 52)],
	[Vector2(1005, 540), Vector2(75, 52)],
	[Vector2(600, 155), Vector2(110, 48)],
	[Vector2(720, 565), Vector2(80, 65)],
	[Vector2(1690, 240), Vector2(100, 60)],
	[Vector2(1950, 970), Vector2(90, 70)],
	[Vector2(870, 1100), Vector2(120, 48)],
	[Vector2(1440, 750), Vector2(80, 80)],
	[Vector2(2230, 180), Vector2(75, 52)],
	[Vector2(275, 1250), Vector2(75, 52)],
	[Vector2(2230, 1250), Vector2(75, 52)]
]
const CRATE_SIZE := Vector2(68, 68)
const CRATES := [
	Vector2(194, 290), Vector2(410, 176), Vector2(490, 310),
	Vector2(762, 223), Vector2(1090, 286), Vector2(270, 385),
	Vector2(440, 470), Vector2(583, 538), Vector2(810, 425),
	Vector2(944, 365), Vector2(1095, 438), Vector2(690, 122),
	Vector2(1340, 270), Vector2(1510, 430), Vector2(1800, 340),
	Vector2(2200, 440), Vector2(2010, 640), Vector2(1660, 900),
	Vector2(2260, 1110), Vector2(1810, 1190), Vector2(1380, 1070),
	Vector2(1040, 920), Vector2(560, 1130), Vector2(380, 980)
]

static func ground_to_3d(point: Vector2, height: float = 0.0) -> Vector3:
	return Vector3(point.x, height, point.y)

static func footprint_to_3d(size: Vector2, height: float) -> Vector3:
	return Vector3(size.x, height, size.y)
