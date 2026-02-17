extends RayCast3D

@onready var dot = $"../../../Hand/Dot"
func _process(_delta):
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("interactable"):
			dot.visible = true
			dot.global_position = get_collision_point()
			dot.global_position += get_collision_normal() * 0.01 
		else:
			dot.visible = false
	else:
		dot.visible = false
