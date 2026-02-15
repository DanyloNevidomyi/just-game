extends CharacterBody3D

const SPEED = 5.0
const SENSITIVITY = 0.003

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var ray_cast = $Head/Camera3D/RayCast3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Обробка всіх натискань клавіш та миші тут
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_mouse_mode()

	# Поворот камери
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	# Взаємодія
	# TODO: Тре "ui_accept" на "interact" замінити
	
	if event.is_action_pressed("ui_accept"): 
		if ray_cast.is_colliding():
			var collider = ray_cast.get_collider()
			if collider.has_method("interact"):
				collider.interact()

# Фізика тільки для руху тіла
const ACCEL = 10.0  # Коефіцієнт прискорення
const FRICTION = 15.0 # Коефіцієнт гальмування
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0 # Обнуляємо, щоб не накопичувалась від'ємна швидкість
# 1. Отримуємо вектор вводу
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

# 2. Визначаємо напрямок відносно повороту голови
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

# 3. Розраховуємо цільову швидкість
	var target_velocity = direction * SPEED

# 4. Плавна зміна швидкості
	if direction:
		# Прискорюємось до цільової швидкості
		velocity.x = lerp(velocity.x, target_velocity.x, ACCEL * delta)
		velocity.z = lerp(velocity.z, target_velocity.z, ACCEL * delta)
	else:
		# Плавно зупиняємось (тертя)
		velocity.x = lerp(velocity.x, 0.0, FRICTION * delta)
		velocity.z = lerp(velocity.z, 0.0, FRICTION * delta)

	move_and_slide()

func toggle_mouse_mode():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
