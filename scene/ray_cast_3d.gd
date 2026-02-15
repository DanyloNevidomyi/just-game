extends RayCast3D

@onready var dot = $"../../../Dot"
@onready var hand = $"../Hand"

var picked_object: RigidBody3D = null
var pull_power = 20.0

func _process(_delta):
	# тут крапка малюєця
	if is_colliding():
		var collider = get_collider()
		if collider.is_in_group("interactable") or collider.is_in_group("pickable"):
			dot.visible = true
			dot.global_position = get_collision_point() + get_collision_normal() * 0.01
		else:
			dot.visible = false
	else:
		dot.visible = false

	# підносимо до носику
	if picked_object:
		hold_object(_delta)

func _input(event):
	if event.is_action_pressed("interact"):
		if picked_object:
			# Якшо в руках тримаємо то із рук кидаємо
			drop_or_throw_object()
		elif is_colliding():
			var target = get_collider()
			
			# перевірка  чи пікабл
			if target.is_in_group("pickable") and target is RigidBody3D:
				pick_up_object(target)
			
			# Перевірка чи кнопка 
			elif target.is_in_group("interactable"):
				interact_with_object(target)

func pick_up_object(obj):
	picked_object = obj
	picked_object.gravity_scale = 0.0
	# Все нахуй вимикаємо якщо в руках
	picked_object.get_node("CollisionShape3D").disabled = true

func hold_object(_delta):
	var target_pos = hand.global_position
	var current_pos = picked_object.global_position
	picked_object.linear_velocity = (target_pos - current_pos) * pull_power
	picked_object.angular_velocity = Vector3.ZERO # хуй зна нашо це але по гайду

func drop_or_throw_object():
	# вмикаємо все нахуй 
	picked_object.get_node("CollisionShape3D").disabled = false
	picked_object.gravity_scale = 1.0
	
	var throw_force = -global_transform.basis.z * 15.0
	picked_object.apply_central_impulse(throw_force)
	picked_object = null

func interact_with_object(obj):
	print("Натиснуто на кнопку: ", obj.name)
	# натискання хз
	if obj.has_method("activate"):
		obj.activate()
