extends CharacterBody3D

@onready var head = $head
@onready var ray_cast_3d = $head/RayCast3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENS = 0.4
var MAX_JUMPS = 2
const RUN_SPEED = 10.0 
var is_running = false 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jump_count = 0



func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
		head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	#if event
	if Input.is_action_pressed("sprint"):
		is_running = true
	else:
		is_running = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		jump_count = 0  # Reset jump counter when on the ground

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var current_speed = RUN_SPEED if is_running else SPEED 
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	#if Input.is_action_pressed("shoot"):
		#shoot()
	move_and_slide()
	
func shoot():
	if ray_cast_3d.is_colliding():
		var colpoint = ray_cast_3d.get_collision_point()
		var normal = ray_cast_3d.get_collision_normal()
		var target = ray_cast_3d.get_collider()
		
		if target != null:
			if target.is_in_group("lift_panel") && target.has_method("witch_floor"):
				target.witch_floor(2)
	
