extends StaticBody3D

signal pressed

@export var next_scene_path: String = "res://level_1.tscn"
@export var push_depth: float = 0.05
@export var push_speed: float = 0.1
@export var fade_speed: float = 2.0

var is_animating: bool = false
@onready var original_position: Vector3 = position

func interact():
	if is_animating:
		return

	is_animating = true
	pressed.emit()
	
	# Анімація фізичної кнопки
	var tween = create_tween()
	var down_pos = original_position + transform.basis.y * -push_depth
	tween.tween_property(self, "position", down_pos, push_speed)
	tween.tween_property(self, "position", original_position, push_speed)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Виклик глобального переходу
	if SceneChanger:
		SceneChanger.fade_to_scene(next_scene_path, fade_speed)
	else:
		printerr("Помилка: SceneChanger не знайдено в Autoload!")
