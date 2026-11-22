extends Control
class_name ArenaInventoryWindow

signal closed
signal inventory_changed

const Catalog = preload("res://scripts/arena_item_catalog.gd")
var store: LocalProfileStore
var character_id := ""
var list: VBoxContainer
var message: Label

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.72)
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	var panel := PanelContainer.new()
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(420, 420)
	panel.position = Vector2(-210, -210)
	add_child(panel)
	var scroll := ScrollContainer.new()
	panel.add_child(scroll)
	list = VBoxContainer.new()
	list.custom_minimum_size.x = 390
	scroll.add_child(list)
	refresh()

func refresh() -> void:
	if list == null or store == null: return
	for child in list.get_children(): child.queue_free()
	var title := Label.new()
	title.text = "Inventário e equipamentos"
	list.add_child(title)
	var character := store.find_character(character_id)
	if character.is_empty(): return
	for slot in Catalog.EQUIPMENT_SLOTS:
		var item_id := str(character["equipment"].get(slot, ""))
		var row := Label.new()
		row.text = "%s: %s" % [slot.capitalize(), "vazio" if item_id == "" else Catalog.item(item_id)["name"]]
		list.add_child(row)
	list.add_child(HSeparator.new())
	for item_id in character["inventory"].keys():
		var definition := Catalog.item(str(item_id))
		if definition.is_empty(): continue
		var button := Button.new()
		button.text = "%s ×%d%s" % [definition["name"], character["inventory"][item_id], " — Equipar" if definition.has("slot") else " — Usar"]
		button.pressed.connect(_use_or_equip.bind(str(item_id)))
		list.add_child(button)
	message = Label.new()
	list.add_child(message)
	var close := Button.new()
	close.text = "Fechar"
	close.pressed.connect(func(): closed.emit())
	list.add_child(close)

func _use_or_equip(item_id: String) -> void:
	if Catalog.is_equipment(item_id):
		if store.equip_item(character_id, item_id):
			inventory_changed.emit()
			refresh()
		else: message.text = store.last_error
	else:
		# Consumíveis são usados pelos atalhos da arena; esta janela informa a quantidade.
		message.text = "Use a poção pelo atalho na arena."
