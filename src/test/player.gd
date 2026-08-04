extends CharacterBody3D


@export var speed: float = 5.0 
@export var jump_velocity: float = 4.5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	var direction = Vector3.ZERO

	if Input.is_action_just_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_just_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_just_pressed("move_back"):
		direction.x += 1
	if Input.is_action_just_pressed("move_right"):
		direction.z += 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
