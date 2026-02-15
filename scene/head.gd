extends Node3D

var sens = 0.12
@onready var ch3d = $".." 
@onready var camera = $Camera3D
@onready var ray_cast = $Camera3D/RayCast3D
@onready var hand = $Camera3D/Hand
@onready var dot = $Camera3D/Hand/Dot

var rotation_x = 0.0
var picked_object: RigidBody3D = null
const THROW_FORCE = 50.0

func _input(event):
	# Керування камерою
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		ch3d.rotate_y(deg_to_rad(-event.relative.x * sens))
		rotation_x -= event.relative.y * sens
		rotation_x = clamp(rotation_x, -80, 80)
		rotation.x = deg_to_rad(rotation_x)

	# Логіка взаємодії (натиснув — підняв / натиснув — кинув)
	if event.is_action_pressed("use"):
		if picked_object:
			# Якщо в руках уже є об'єкт — кидаємо його
			throw_object()
		else:
			# Якщо руки порожні — перевіряємо, що перед нами
			if ray_cast.is_colliding():
				var collider = ray_cast.get_collider()
				
				# Пріоритет 1: Об'єкти, які можна підняти
				if collider is RigidBody3D and collider.is_in_group("pickable"):
					pick_up_object(collider)
				
				# Пріоритет 2: Кнопки/важелі (interact)
				elif collider.has_method("interact"):
					collider.interact()

func _physics_process(_delta):
	_update_object_position()
	_update_dot_visibility()

func _update_object_position():
	if picked_object:
		# Плавне або жорстке слідування за рукою
		picked_object.global_position = hand.global_position
		picked_object.global_rotation = hand.global_rotation
		picked_object.linear_velocity = Vector3.ZERO
		picked_object.angular_velocity = Vector3.ZERO

func _update_dot_visibility():
	if picked_object:
		dot.visible = false
		return

	if ray_cast.is_colliding():
		var object = ray_cast.get_collider()
		if object.is_in_group("interactable") or object.is_in_group("pickable"):
			dot.visible = true
			dot.global_position = ray_cast.get_collision_point() + ray_cast.get_collision_normal() * 0.01
		else:
			dot.visible = false
	else:
		dot.visible = false

func pick_up_object(object):
	picked_object = object
	picked_object.collision_layer = 2 # Вимикаємо колізію з гравцем
	# Вимикаємо гравітацію, щоб об'єкт не "тягнуло" вниз, поки він у руках
	picked_object.freeze = false 

func throw_object():
	var throw_dir = -camera.global_transform.basis.z
	picked_object.collision_layer = 1 # Повертаємо колізію
	picked_object.apply_central_impulse(throw_dir * THROW_FORCE)
	picked_object = null
