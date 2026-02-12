extends CharacterBody2D

var speed = 150.0
@export var player: Node2D

# Отримуємо посилання на наш "GPS" (ноду, яку ми додали на Кроці 2)
@onready var nav_agent := $NavigationAgent2D

func _physics_process(_delta):
	# Якщо гравця немає - стоїмо
	if !player:
		return
		
	# 1. Кажемо агенту: "Ми хочемо дійти до гравця"
	nav_agent.target_position = player.global_position
	
	# 2. Агент рахує шлях і каже, де наступна точка повороту
	var next_path_position = nav_agent.get_next_path_position()
	
	# 3. Рухаємось не до гравця, а до цієї НАСТУПНОЇ точки
	var direction = global_position.direction_to(next_path_position)
	velocity = direction * speed
	
	move_and_slide()

# Тут твій старий код для вбивства (залиш його без змін)
func _on_kill_zone_body_entered(body):
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://scene/game_over_scene.tscn")
