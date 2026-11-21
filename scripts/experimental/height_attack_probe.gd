extends RefCounted
class_name HeightAttackProbe

const REACH := 3.5
const MAX_HEIGHT_DIFFERENCE := 1.2

static func inspect(space: PhysicsDirectSpaceState3D, origin: Vector3, target: Vector3, reach: float = REACH, height_tolerance: float = MAX_HEIGHT_DIFFERENCE) -> Dictionary:
	var horizontal := Vector2(origin.x, origin.z).distance_to(Vector2(target.x, target.z))
	var height_difference := absf(origin.y - target.y)
	if horizontal > reach:
		return {"can_hit": false, "reason": "horizontal_range", "horizontal": horizontal, "height": height_difference}
	if height_difference > height_tolerance:
		return {"can_hit": false, "reason": "height", "horizontal": horizontal, "height": height_difference}
	var query := PhysicsRayQueryParameters3D.create(origin + Vector3.UP, target + Vector3.UP)
	query.collision_mask = 1
	var hit := space.intersect_ray(query)
	return {"can_hit": hit.is_empty(), "reason": "clear" if hit.is_empty() else "cover", "horizontal": horizontal, "height": height_difference}
