extends RefCounted
class_name ServerRoom

const MIN_PLAYERS := 2
const MAX_PLAYERS := 5
const RECONNECT_SECONDS := 60.0

var state := "waiting"
var members: Dictionary = {}
var started_at := 0.0
var result: Dictionary = {}

func join(account_id: String, peer_id: int, preset_id: String, now: float) -> Dictionary:
	if account_id == "" or peer_id <= 0 or preset_id == "":
		return {"ok": false, "error": "Identidade ou configuração inválida."}
	if members.has(account_id):
		var member: Dictionary = members[account_id]
		if int(member["peer_id"]) != 0:
			return {"ok": false, "error": "Conta já está conectada."}
		if float(member["disconnected_at"]) + RECONNECT_SECONDS <= now:
			return {"ok": false, "error": "Tempo de reconexão encerrado."}
		if not bool(member["alive"]):
			return {"ok": false, "error": "Personagem já foi eliminado."}
		if str(member["preset_id"]) != preset_id:
			return {"ok": false, "error": "Configuração diferente da partida."}
		member["peer_id"] = peer_id
		member["disconnected_at"] = -1.0
		members[account_id] = member
		return {"ok": true, "resumed": true}
	if state != "waiting" or members.size() >= MAX_PLAYERS:
		return {"ok": false, "error": "Sala indisponível."}
	for member in members.values():
		if int(member["peer_id"]) == peer_id:
			return {"ok": false, "error": "Conexão já ocupa uma vaga."}
	members[account_id] = {"peer_id": peer_id, "preset_id": preset_id, "ready": false, "disconnected_at": -1.0, "alive": true}
	return {"ok": true, "resumed": false}

func ready(account_id: String, peer_id: int) -> bool:
	if state != "waiting" or not members.has(account_id) or int(members[account_id]["peer_id"]) != peer_id:
		return false
	members[account_id]["ready"] = true
	return true

func can_start() -> bool:
	if state != "waiting" or members.size() < MIN_PLAYERS or members.size() > MAX_PLAYERS:
		return false
	for member in members.values():
		if not bool(member["ready"]) or int(member["peer_id"]) == 0:
			return false
	return true

func start(now: float) -> bool:
	if not can_start():
		return false
	state = "active"
	started_at = now
	return true

func disconnect_peer(peer_id: int, now: float) -> String:
	for account_id in members.keys():
		var member: Dictionary = members[account_id]
		if int(member["peer_id"]) == peer_id:
			member["peer_id"] = 0
			member["disconnected_at"] = now
			if state == "waiting":
				member["ready"] = false
			members[account_id] = member
			return account_id
	return ""

func tick(now: float) -> Array[String]:
	var expired: Array[String] = []
	for account_id in members.keys():
		var member: Dictionary = members[account_id]
		if int(member["peer_id"]) == 0 and float(member["disconnected_at"]) >= 0.0 and now - float(member["disconnected_at"]) >= RECONNECT_SECONDS:
			expired.append(account_id)
			if state == "waiting":
				members.erase(account_id)
			else:
				member["alive"] = false
				member["disconnected_at"] = -1.0
				members[account_id] = member
	return expired

func alive_ids() -> Array[String]:
	var ids: Array[String] = []
	for account_id in members.keys():
		if bool(members[account_id]["alive"]):
			ids.append(account_id)
	return ids

func finish(winner_id: String, reason: String) -> void:
	if state != "active":
		return
	state = "results"
	result = {"winner_id": winner_id, "reason": reason}
