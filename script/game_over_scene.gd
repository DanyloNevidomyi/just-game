extends Control

func _ready():
	# Знаходимо плеєр (через знак $ звертаємось до дитини)
	# Підключаємо сигнал "finished" до нашої функції
	$VideoStreamPlayer.finished.connect(_on_video_finished)

func _on_video_finished():
	# Коли відео закінчилось -> вантажимо Головне Меню
	get_tree().change_scene_to_file("res://scene/mainMenu.tscn") # Перевір назву свого файлу меню!
