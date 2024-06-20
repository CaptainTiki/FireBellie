extends CharacterBody2D

var maxHorizontalSpeed = 400
var horizontalAcceleration = 200
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(delta):
	pass


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var moveVector = Input.get_axis("Move_Left", "Move_Right")
	if moveVector:
		velocity.x += moveVector * horizontalAcceleration * delta
	else:
		velocity.x = move_toward(velocity.x, 0, horizontalAcceleration)

	velocity.x = clamp(velocity.x, -maxHorizontalSpeed)
	move_and_slide()
