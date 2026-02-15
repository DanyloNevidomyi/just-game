extends StaticBody3D

signal pressed_event  # Сигнал

@export var push_depth: float = 0.05
@export var push_speed: float = 0.1

var is_animating: bool = false
@onready var original_position: Vector3 = position

func interact():
	if is_animating:
		return

	is_animating = true
	
	# Анімація 
	var tween = create_tween()
	var down_pos = original_position + transform.basis.y * -push_depth
	
	tween.tween_property(self, "position", down_pos, push_speed)
	tween.tween_property(self, "position", original_position, push_speed)
	
	# Чекаємо завершення анімації
	await tween.finished
	is_animating = false
	
	# Сповіщаємо світ, що натискання відбулося
	pressed_event.emit()
