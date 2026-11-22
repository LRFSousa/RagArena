extends RefCounted
class_name ArenaDerivedStats

const Attributes = preload("res://scripts/arena_attributes.gd")
const ItemCatalog = preload("res://scripts/arena_item_catalog.gd")
const HP_CURVES := {
	"swordsman": [1000, 3000, 6000],
	"thief": [900, 2600, 5000],
	"archer": [850, 2400, 4600],
	"acolyte": [900, 2500, 4800],
	"mage": [800, 2100, 4000]
}

static func base_hp(class_id: String, level: int) -> int:
	var points: Array = HP_CURVES.get(class_id, HP_CURVES["swordsman"])
	var capped := clampi(level, 1, 40)
	if capped <= 20:
		return roundi(lerpf(float(points[0]), float(points[1]), float(capped - 1) / 19.0))
	return roundi(lerpf(float(points[1]), float(points[2]), float(capped - 20) / 20.0))

# Escala própria da arena. Os componentes seguem os papéis dos atributos
# Pre-Renewal; não representam os números finais do servidor Ragnarok.
static func calculate(character: Dictionary) -> Dictionary:
	var s := Attributes.effective_value(character, "for")
	var a := Attributes.effective_value(character, "agi")
	var v := Attributes.effective_value(character, "vit")
	var i := Attributes.effective_value(character, "int")
	var d := Attributes.effective_value(character, "des")
	var l := Attributes.effective_value(character, "sor")
	var level := maxi(1, int(character.get("base_level", 1)))
	var atk := 14 + s + (s / 10) * (s / 10) + d / 5 + l / 5
	var hp := roundi(float(base_hp(str(character.get("class_id", "swordsman")), level)) * (1.0 + float(v) / 100.0))
	var equip_atk := 0
	var equip_def := 0
	var equip_hp := 0
	var equipment: Dictionary = character.get("equipment", {})
	for slot in ItemCatalog.EQUIPMENT_SLOTS:
		var definition := ItemCatalog.item(str(equipment.get(slot, "")))
		equip_atk += int(definition.get("atk", 0))
		equip_def += int(definition.get("def", 0))
		equip_hp += int(definition.get("hp", 0))
	atk += equip_atk
	hp += equip_hp
	return {
		"hp": hp,
		"sp": 30 + level + i * 2,
		"hp_regen": 1 + v / 5,
		"sp_regen": 1 + i / 6,
		"atk": atk,
		"basic_damage": maxi(1, roundi(float(atk) * (2.5 + 0.22 * float(level - 1)))),
		"matk": 5 + i + (i / 5) * (i / 5),
		"def": v + equip_def,
		"mdef": i + v / 2,
		"hit": 80 + level + d + l / 3,
		"flee": 80 + level + a + l / 5,
		"move_speed": 8.0,
		"attack_speed": minf(150.0, 100.0 + a * 0.4 + d * 0.1),
		"range": 2
	}
