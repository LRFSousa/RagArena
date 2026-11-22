extends Node3D

const STONE_SHADER = preload("res://shaders/vespera_stone.gdshader")
# O muro grande define a referência. A correção afeta pedra e musgo
# separadamente, preservando detalhes coloridos e mapas PBR dos GLBs.
const SETTINGS := {
	"Mural de Castelo Grande": Vector2(1.0, 1.0),
	"Mural de Castelo Quebrado": Vector2(1.0, 0.72),
	"Portão Principal": Vector2(1.22, 0.90),
	"Torre": Vector2(0.74, 1.0)
}

func _ready() -> void:
	var wall_group := get_node_or_null("MuroCidade")
	if wall_group == null:
		return
	var cached_materials: Dictionary = {}
	for model in wall_group.get_children():
		for prefix in SETTINGS:
			if str(model.name).begins_with(prefix):
				_apply_palette(model, prefix, cached_materials)
				break

func _apply_palette(node: Node, model_type: String, cache: Dictionary) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		for surface in mesh_instance.mesh.get_surface_count():
			var original := mesh_instance.mesh.surface_get_material(surface)
			if not original is StandardMaterial3D:
				continue
			var cache_key := "%s:%d" % [model_type, surface]
			if not cache.has(cache_key):
				var source := original as StandardMaterial3D
				var corrected := ShaderMaterial.new()
				corrected.shader = STONE_SHADER
				corrected.set_shader_parameter("base_color_map", source.albedo_texture)
				corrected.set_shader_parameter("normal_map", source.normal_texture)
				corrected.set_shader_parameter("rm_map", source.roughness_texture)
				corrected.set_shader_parameter("stone_gain", SETTINGS[model_type].x)
				corrected.set_shader_parameter("moss_gain", SETTINGS[model_type].y)
				cache[cache_key] = corrected
			mesh_instance.set_surface_override_material(surface, cache[cache_key])
	for child in node.get_children():
		_apply_palette(child, model_type, cache)
