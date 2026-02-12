extends StaticBody3D

signal pressed_event

@export var push_depth: float = 0.05
@export var push_speed: float = 0.2

var is_spent: bool = false # Прапорець "використано"
@onready var original_position: Vector3 = position

func interact():
	if is_spent:
		return

	is_spent = true 
	
	# Анімація
	var tween = create_tween()
	var down_pos = original_position + transform.basis.y * -push_depth
	
	tween.tween_property(self, "position", down_pos, push_speed)
	tween.tween_property(self, "position", original_position, push_speed)
	

	pressed_event.emit()
