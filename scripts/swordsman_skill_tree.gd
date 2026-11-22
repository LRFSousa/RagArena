extends RefCounted
class_name SwordsmanSkillTree

# IDs estáveis para persistência. Os nomes exibidos poderão mudar.
const SKILLS := [
	{"id": "SM_SWORD", "name": "Perícia com Espada", "max": 10, "requires": {}},
	{"id": "SM_TWOHAND", "name": "Perícia com Espada de Duas Mãos", "max": 10, "requires": {"SM_SWORD": 1}},
	{"id": "SM_RECOVERY", "name": "Aumentar Recuperação de HP", "max": 10, "requires": {}},
	{"id": "SM_BASH", "name": "Golpe Fulminante", "max": 10, "requires": {}},
	{"id": "SM_PROVOKE", "name": "Provocar", "max": 10, "requires": {}},
	{"id": "SM_MAGNUM", "name": "Impacto Explosivo", "max": 10, "requires": {"SM_BASH": 5}},
	{"id": "SM_ENDURE", "name": "Vigor", "max": 10, "requires": {"SM_PROVOKE": 5}}
]

const QUEST_SKILLS := [
	{"id": "SM_MOVINGRECOVERY", "name": "Recuperar HP em Movimento"},
	{"id": "SM_FATALBLOW", "name": "Golpe Fatal"},
	{"id": "SM_AUTOBERSERK", "name": "Instinto de Sobrevivência"}
]

static func definition(id: String) -> Dictionary:
	for skill in SKILLS:
		if skill["id"] == id:
			return skill
	return {}

static func rank(character: Dictionary, id: String) -> int:
	return int(character.get("skill_ranks", {}).get(id, 0))

static func can_spend(character: Dictionary, id: String) -> bool:
	if str(character.get("class_id", "")) != "swordsman" or int(character.get("skill_points", 0)) <= 0:
		return false
	var skill := definition(id)
	if skill.is_empty() or rank(character, id) >= int(skill["max"]):
		return false
	for required_id in skill["requires"]:
		if rank(character, required_id) < int(skill["requires"][required_id]):
			return false
	return true
