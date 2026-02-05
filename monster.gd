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


func _on_kill_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", "res://game_over_scene.tscn")
