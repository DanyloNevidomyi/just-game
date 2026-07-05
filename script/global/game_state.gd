extends Node

signal money_changed(value: int)
signal hp_changed(value: float)
signal sanity_changed(value: float)
signal player_died
signal sanity_depleted

var money: int = 0
var hp: float = 100.0
var max_hp: float = 100.0
var sanity: float = 100.0
var max_sanity: float = 100.0

const SAVE_PATH = "user://save.json"

func add_money(amount: int) -> void:
	money += amount
	money_changed.emit(money)

func spend_money(amount: int) -> bool:
	if money < amount:
		return false
	money -= amount
	money_changed.emit(money)
	return true

func damage(amount: float) -> void:
	hp = clamp(hp - amount, 0.0, max_hp)
	hp_changed.emit(hp)
	if hp <= 0.0:
		player_died.emit()

func heal(amount: float) -> void:
	hp = clamp(hp + amount, 0.0, max_hp)
	hp_changed.emit(hp)

func drain_sanity(amount: float) -> void:
	sanity = clamp(sanity - amount, 0.0, max_sanity)
	sanity_changed.emit(sanity)
	if sanity <= 0.0:
		sanity_depleted.emit()

func restore_sanity(amount: float) -> void:
	sanity = clamp(sanity + amount, 0.0, max_sanity)
	sanity_changed.emit(sanity)

func save_game() -> void:
	var data = {
		"money": money,
		"hp": hp,
		"sanity": sanity
	}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	if data == null:
		return false
	money = data.get("money", 0)
	hp = data.get("hp", 100.0)
	sanity = data.get("sanity", 100.0)
	money_changed.emit(money)
	hp_changed.emit(hp)
	sanity_changed.emit(sanity)
	return true

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)
