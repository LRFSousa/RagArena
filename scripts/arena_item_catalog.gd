extends RefCounted
class_name ArenaItemCatalog

# Valores provisórios do RagnArena; apenas a organização dos itens usa rAthena como referência.
const ITEMS := {
	"training_sword": {"name": "Espada de treino", "slot": "weapon", "atk": 8, "max_stack": 1},
	"iron_sword": {"name": "Espada de ferro", "slot": "weapon", "atk": 22, "max_stack": 1},
	"cloth_armor": {"name": "Armadura de pano", "slot": "armor", "def": 8, "max_stack": 1},
	"iron_armor": {"name": "Armadura de ferro", "slot": "armor", "def": 22, "max_stack": 1},
	"leather_cap": {"name": "Capacete de couro", "slot": "helmet", "def": 5, "max_stack": 1},
	"vital_ring": {"name": "Anel vital", "slot": "accessory", "hp": 150, "max_stack": 1},
	"health_potion": {"name": "Poção de vida", "heal_percent": 20, "max_stack": 99},
	"elixir": {"name": "Elixir", "heal_percent": 40, "max_stack": 99}
}

const EQUIPMENT_SLOTS := ["weapon", "armor", "helmet", "accessory"]

static func item(item_id: String) -> Dictionary:
	return ITEMS.get(item_id, {})

static func is_equipment(item_id: String) -> bool:
	return item(item_id).has("slot")
