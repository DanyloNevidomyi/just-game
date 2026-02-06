extends Node

var achievement_scene = preload("res://scene/achivement.tscn")

# Список розблокованих ачівок 
var unlocked_achievements = []

# Словник: Ключ = назва, Значення = шлях до картинки
var icons = {
	"jumpscare": {
		"tex": preload("res://pics/Billy.jpg"),
		"color": Color.WHITE # Деф колір
	},
	"jumpscare_red": {
		"tex": preload("res://pics/Billy.jpg"),
		"color": Color.RED # Новий колір
	},
	"gambling": {
		"tex": preload("res://pics/ebaka2.png"),
		"color": Color.GREEN 
  }

}

func unlock(id: String, display_text: String):
	if id in unlocked_achievements: return
	
	unlocked_achievements.append(id)
	
	var ach = achievement_scene.instantiate()
	add_child(ach)
	
	
	var data = icons.get(id, {"tex": preload("res://pics/icon.svg"), "color": Color.WHITE})
	
	
	ach.display(display_text, data.tex, data.color)
