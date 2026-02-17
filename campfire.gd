extends Area3D

@export var fire_energy: float = 50.0  # Початкова сила вогню (0-100)
@export var decay_rate: float = 2.0    # Скільки сили втрачається за секунду
@export var fuel_boost: float = 20.0   # Скільки сили додає один предмет

@onready var particles = $GPUParticles3D



func _process(delta):
	# Зменшуємо силу вогню з часом
	if fire_energy > 0:
		fire_energy -= decay_rate * delta
		fire_energy = clamp(fire_energy, 0, 100)
		update_fire_visuals()

func _on_body_entered(body):
	print("Предмет зайшов!")
	# Перевіряємо, чи об'єкт належить до групи "flameable"
	if body.is_in_group("flameable"):
		burn_item(body)

func burn_item(item):
	fire_energy += fuel_boost
	fire_energy = clamp(fire_energy, 0, 100)
	
	# Ефект "згорання": можна додати звук або спалах перед видаленням
	item.queue_free() 
	print("Предмет спалено! Поточна сила: ", fire_energy)

func update_fire_visuals():
	# Перетворюємо силу (0-100) у коефіцієнт (0.0-1.0)
	var ratio = fire_energy / 100.0
	
	# amount_ratio — це найкращий спосіб змінювати кількість на льоту
	particles.amount_ratio = ratio
	
	# Якщо енергія 0, повністю вимикаємо емісію
	if fire_energy <= 0:
		particles.emitting = false
	else:
		particles.emitting = true
