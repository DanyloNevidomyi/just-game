extends CharacterBody2D

var speed = 150.0
@export var player: Node2D # Це "порожнє місце", куди ми пізніше покладемо гравця

func _physics_process(_delta):
	# Монстр рухається тільки якщо ми сказали йому, хто такий "player"
	if player:
		# Дивимось, де гравець, і йдемо до нього
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()
