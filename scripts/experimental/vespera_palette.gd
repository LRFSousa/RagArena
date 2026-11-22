extends Node3D

# O muro grande define o tom de pedra. Correções pequenas nos materiais
# importados mantêm as texturas, mapas normais e detalhes de cada modelo.
const TINTS := {
	"Mural de Castelo Grande": Color(1.0, 1.0, 1.0),
	"Mural de Castelo Quebrado": Color(1.01, 1.02, 1.04),
	"Portão Principal": Color(1.30, 1.32, 1.35),
	"Torre": Color(0.82, 0.84, 0.86)
}

func _ready() -> void:
	var wall_group := get_node_or_null("MuroCidade")
	if wall_group == null:
		return
	var cached_materials: Dictionary = {}
	for model in wall_group.get_children():
		var model_name := str(model.name).trim_suffix("2").trim_suffix("3").trim_suffix("4").trim_suffix("5")
		for prefix in TINTS:
			if model_name.begins_with(prefix):
				_apply_tint(model, prefix, cached_materials)
				break

func _apply_tint(node: Node, model_type: String, cache: Dictionary) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		for surface in mesh_instance.mesh.get_surface_count():
			var original := mesh_instance.get_active_material(surface)
			if not original is StandardMaterial3D:
				continue
			var cache_key := "%s:%d" % [model_type, surface]
			if not cache.has(cache_key):
				var corrected := (original as StandardMaterial3D).duplicate() as StandardMaterial3D
				corrected.albedo_color = TINTS[model_type]
				cache[cache_key] = corrected
			mesh_instance.set_surface_override_material(surface, cache[cache_key])
	for child in node.get_children():
		_apply_tint(child, model_type, cache)
