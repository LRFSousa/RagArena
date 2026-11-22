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

# Organização visual independente dos IDs e ranks persistidos.
const LINES := [
	{"id": "combat", "name": "Combate", "icon": "⚔", "skills": ["SM_BASH", "SM_MAGNUM"]},
	{"id": "defense", "name": "Defesa", "icon": "◆", "skills": ["SM_PROVOKE", "SM_ENDURE"]},
	{"id": "swords", "name": "Espadas", "icon": "✦", "skills": ["SM_SWORD", "SM_TWOHAND"]},
	{"id": "recovery", "name": "Recuperação", "icon": "✚", "skills": ["SM_RECOVERY"]},
	{"id": "special", "name": "Especiais", "icon": "✧", "skills": ["SM_MOVINGRECOVERY", "SM_FATALBLOW", "SM_AUTOBERSERK"]}
]
const DETAILS := {
	"SM_BASH": {"kind": "Ativa", "text": "Golpe físico em um alvo.", "range": "2 blocos", "cost": "8 SP (ranks 1–5); 15 SP (6–10)"},
	"SM_MAGNUM": {"kind": "Ativa", "text": "Ataque de área ao redor do personagem.", "range": "Área próxima", "cost": "30 SP e HP conforme o rank"},
	"SM_PROVOKE": {"kind": "Ativa", "text": "Enfraquece um alvo. O efeito PvP ainda será definido.", "range": "Alvo", "cost": "4–13 SP conforme o rank"},
	"SM_ENDURE": {"kind": "Suporte", "text": "Reduz a reação ao receber ataques.", "range": "Pessoal", "cost": "10 SP"},
	"SM_SWORD": {"kind": "Passiva", "text": "Aumenta a perícia com espada de uma mão.", "range": "Pessoal", "cost": "Sem SP"},
	"SM_TWOHAND": {"kind": "Passiva", "text": "Aumenta a perícia com espada de duas mãos.", "range": "Pessoal", "cost": "Sem SP"},
	"SM_RECOVERY": {"kind": "Passiva", "text": "Melhora a recuperação de HP.", "range": "Pessoal", "cost": "Sem SP"}
}

static func line(id: String) -> Dictionary:
	for item in LINES:
		if item["id"] == id: return item
	return {}

static func display_definition(id: String) -> Dictionary:
	var regular := definition(id)
	if not regular.is_empty(): return regular
	for item in QUEST_SKILLS:
		if item["id"] == id: return item
	return {}

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
