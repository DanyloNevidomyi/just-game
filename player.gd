extends CharacterBody2D

var speed = 300.0 # Швидкість бігу

func _physics_process(_delta):
	# Отримуємо натискання кнопок (вліво, вправо, вгору, вниз)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO # Зупинка

	move_and_slide()
