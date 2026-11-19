extends Resource
class_name MatchSettings

# Cronograma e geometria provisórios para playtest offline.
@export_range(2, 5, 1) var participants := 3
@export_range(10.0, 3600.0, 1.0) var time_limit := 480.0
@export_range(0.0, 3600.0, 1.0) var shrink_start := 300.0
@export_range(1.0, 1800.0, 1.0) var shrink_duration := 180.0
@export_range(0.0, 120.0, 1.0) var warning_lead := 30.0
@export_range(0.0, 300.0, 1.0) var max_inset := 240.0
@export_range(0.1, 10.0, 0.1) var wall_update_interval := 1.0

func safe_rect(arena_rect: Rect2, elapsed: float) -> Rect2:
	var ratio := clampf((elapsed - shrink_start) / shrink_duration, 0.0, 1.0)
	var inset := minf(max_inset * ratio, minf(arena_rect.size.x, arena_rect.size.y) * 0.5 - 32.0)
	return arena_rect.grow(-inset)
