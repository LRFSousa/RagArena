extends SceneTree

const Room = preload("res://scripts/server_room.gd")
var failures := 0

func _initialize() -> void:
	call_deferred("run_tests")

func check(condition: bool, label: String) -> void:
	if condition:
		print("PASS: ", label)
	else:
		failures += 1
		push_error("FAIL: " + label)

func run_tests() -> void:
	for count in range(2, 6):
		var room = Room.new()
		for i in range(count):
			check(room.join("account-%d" % i, i + 2, "preset-%d" % i, 0.0).get("ok", false), "%d: jogador %d entra" % [count, i + 1])
		check(not room.can_start(), "%d: sala espera confirmação" % count)
		for i in range(count):
			check(room.ready("account-%d" % i, i + 2), "%d: jogador %d fica pronto" % [count, i + 1])
		check(room.start(10.0) and room.state == "active" and room.alive_ids().size() == count, "%d: início sincronizado" % count)
		check(not room.join("extra", 99, "preset-extra", 11.0).get("ok", true), "%d: entrada após início rejeitada" % count)
	var full = Room.new()
	for i in range(5):
		full.join("id%d" % i, i + 2, "preset%d" % i, 0.0)
	check(not full.join("sixth", 7, "preset6", 0.0).get("ok", true), "sexta vaga rejeitada")
	var duplicate_peer = Room.new()
	duplicate_peer.join("first", 2, "preset", 0.0)
	check(not duplicate_peer.join("second", 2, "preset", 0.0).get("ok", true), "mesma conexão não ocupa duas vagas")
	duplicate_peer.ready("first", 2)
	duplicate_peer.disconnect_peer(2, 5.0)
	check(not duplicate_peer.members["first"]["ready"], "desconexão na espera cancela prontidão")
	check(not duplicate_peer.join("first", 3, "other", 6.0).get("ok", true), "reconexão não troca configuração")
	check(not duplicate_peer.join("first", 3, "preset", 65.0).get("ok", true), "reconexão no limite de 60 s expira")
	var reconnect = Room.new()
	reconnect.join("owner", 2, "preset", 0.0)
	reconnect.join("other", 3, "preset", 0.0)
	reconnect.ready("owner", 2)
	reconnect.ready("other", 3)
	reconnect.start(0.0)
	check(reconnect.disconnect_peer(2, 10.0) == "owner", "desconexão reserva personagem")
	check(reconnect.join("owner", 4, "preset", 69.0).get("resumed", false), "reconexão em menos de 60 s")
	reconnect.disconnect_peer(4, 100.0)
	check(reconnect.tick(159.0).is_empty() and reconnect.members["owner"]["alive"], "personagem segue reservado até 60 s")
	check(reconnect.tick(160.0).size() == 1 and not reconnect.members["owner"]["alive"], "expiração elimina após 60 s")
	check(not reconnect.join("owner", 5, "preset", 161.0).get("ok", true), "retorno tardio não ressuscita personagem")
	if failures == 0:
		print("RELEASE 0.6 SALA: todos os testes passaram")
	quit(0 if failures == 0 else 1)
