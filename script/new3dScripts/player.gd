extends CharacterBody3D

@onready var head: Node3D = $Head
@onready var grabbed_anchor: Marker3D = $Head/SpringArm3D/GrabbedAnchor
@onready var object_grabber_shape_cast: ShapeCast3D =$Head/ObjectGrabberShapeCast


var grabbed_object:RigidBody3D= null



var SPRINT = 10.0
var SPEED = 5.0
const JUMP_VELOCITY = 4.5

var MOUSE_SENS:float = 0.003

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("sprint"):
		SPEED = SPRINT
	else:
		SPEED = 5
	
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input move_direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var move_direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if move_direction:
		velocity.x = move_direction.x * SPEED
		velocity.z = move_direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	if grabbed_object:
		#grabbed_object.global_position = 
		var target_pos:Vector3 = grabbed_anchor.global_position
		var current_pos:Vector3 = grabbed_object.global_position
		
		var direction = target_pos - current_pos
		var required_velocity = direction/delta
		var velocity_correction = required_velocity - grabbed_object.linear_velocity
		grabbed_object.linear_velocity = required_velocity
		grabbed_object.angular_velocity *=0.1 
		





func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_mouse_mode()
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var y_rot: float = -event.relative.x *MOUSE_SENS
		rotate_y(y_rot) 
		var x_tilt: float = -event.relative.y *MOUSE_SENS
		head.rotate_x(x_tilt)
	elif event is InputEventMouseButton:
		if Input.is_action_just_pressed("interact"):
			if grabbed_object:  
				grabbed_object=null
			elif object_grabber_shape_cast.is_colliding():
				var collided = object_grabber_shape_cast.get_collision_result()[0]["collider"]
				if collided is RigidBox:
					if !grabbed_object:
						try_grabbing(collided)
					#elif collided is StaticBody3D:
					#	pass #continue the logic
		elif Input.is_action_just_pressed("interact2"):
			if grabbed_object: 
				throw_object()



func try_grabbing(collided:RigidBody3D): 
	grabbed_object = collided
	
func throw_object(): 
	grabbed_object.apply_impulse((-head.global_basis.z*5.0)+Vector3(0.0, 1.0, 0.0))
	grabbed_object = null
	
### TEST AREA ###

func toggle_mouse_mode():
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
