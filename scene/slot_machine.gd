extends StaticBody3D


@export var start_button: StaticBody3D# Сюди перетягуєш свою кнопку в інспекторі
@export var next_scene_path: String = "res://scene/level_1.tscn"

func _ready():
	# Підписуємось на сигнал кнопки
	if start_button:
		start_button.pressed_event.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	print("Кнопку натиснуто! Міняємо сцену...")
	AchievementManager.unlock("gambling", "Lest go gambling!!!")
	if SceneChanger:
		SceneChanger.fade_to_scene(next_scene_path, 2.0)
