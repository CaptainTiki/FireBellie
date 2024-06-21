extends CharacterBody2D

@export var maxHorizontalSpeed : int = 250
@export var horizontalAcceleration : int = 1200
@export var jumpVelocity : int = -450
@export var JumpTerminationMultiplier = 3
var hasDoubleJump

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(_delta):
	var wasOnFloor = is_on_floor()
	move_and_slide()
	if (wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()
	
	if(is_on_floor()):
		hasDoubleJump = true
	pass

func _physics_process(delta):
	var moveVector = _getMovementVector(delta)
		# Handle jump. If jump pressed, we're on the floor OR coyote timer is playing:
	if Input.is_action_just_pressed("Jump") and (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump):
		velocity.y = jumpVelocity
		if (!is_on_floor() && $CoyoteTimer.is_stopped()):
			hasDoubleJump = false
		$CoyoteTimer.stop()
	# Add the gravity - use more gravity - if we've let go of the button
	if (velocity.y < 0  && !Input.is_action_pressed("Jump")):
		velocity.y += gravity * JumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta      #standard gravity
	
	#clamp velocity to max horizontal speed
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	update_animation(moveVector)


func _getMovementVector(delta : float):
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var moveVector = Input.get_axis("Move_Left", "Move_Right")
	if moveVector:
		velocity.x += moveVector * horizontalAcceleration * delta
	else:
		velocity.x = lerp(0.0, velocity.x, pow(2.0, -25 * delta))
	return moveVector

func update_animation(moveVec):	
	if (!is_on_floor()):
		$AnimatedSprite2D.play("Jump")
	elif (moveVec != 0):
		$AnimatedSprite2D.play("Run")
	else:
		$AnimatedSprite2D.play("Idle")
	
	#flip the sprite left and right
	if (moveVec != 0): #don't run unless input is pressed
		$AnimatedSprite2D.flip_h = true if moveVec > 0 else false
			
