extends Area3D

@export var fire_energy: float = 50.0
@export var decay_rate: float = 2.0
@export var fuel_boost: float = 30.0
@export var sanity_drain_rate: float = 1.0
@export var sanity_regen_rate: float = 1.0
@export var refuel_reward: int = 20

@onready var particles = $GPUParticles3D

func _process(delta):
	if fire_energy > 0:
		fire_energy -= decay_rate * delta
		fire_energy = clamp(fire_energy, 0, 100)
		GameState.restore_sanity(sanity_regen_rate * delta)
	else:
		GameState.drain_sanity(sanity_drain_rate * delta)

	update_fire_visuals()

func _on_body_entered(body):
	if body.is_in_group("flameable"):
		burn_item(body)

func burn_item(item):
	fire_energy += fuel_boost
	fire_energy = clamp(fire_energy, 0, 100)
	GameState.add_money(refuel_reward)
	item.queue_free()

func update_fire_visuals():
	var ratio = fire_energy / 100.0
	particles.amount_ratio = ratio
	particles.emitting = fire_energy > 0
