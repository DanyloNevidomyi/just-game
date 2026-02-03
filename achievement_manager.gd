extends Node

var achievement_scene = preload("res://achivement.tscn")

# Список уже розблокованих ачівок (щоб не показувати двічі)
var unlocked_achievements = []

# Словник: Ключ = назва, Значення = шлях до картинки
var icons = {
	"jumpscare": {
		"tex": preload("res://Billy.jpg"),
		"color": Color.WHITE # Звичайна картинка
	},
	"jumpscare_red": {
		"tex": preload("res://Billy.jpg"),
		"color": Color.RED # Та сама картинка, але пофарбована в червоний
	}
}

func unlock(id: String, display_text: String):
	if id in unlocked_achievements: return
	
	unlocked_achievements.append(id)
	
	var ach = achievement_scene.instantiate()
	add_child(ach)
	
	# Отримуємо дані зі словника (або дефолтні, якщо ID не знайдено)
	var data = icons.get(id, {"tex": preload("res://icon.svg"), "color": Color.WHITE})
	
	# Передаємо в плашку і текст, і текстуру, і колір
	ach.display(display_text, data.tex, data.color)
