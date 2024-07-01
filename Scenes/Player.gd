extends CharacterBody2D

signal died

enum State {NORMAL, DASHING}

@export var maxHorizontalSpeed : int = 250
@export var horizontalAcceleration : int = 1200
@export var jumpVelocity : int = -450
@export var JumpTerminationMultiplier = 3
@export var MaxDashSpeed = 600
@export var MinDashSpeed = 250
@export var DashDecay = -5
@export_flags_2d_physics var DashHazardMask

var hasDoubleJump = false
var hasDash = false
var currentState = State.NORMAL
var isStateNew = true
var defaultHazardMask

# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	$HazardArea.connect("area_entered", on_hazard_area_entered)
	defaultHazardMask = $HazardArea.collision_mask


func _process(_delta):
	if (Input.is_action_just_pressed("Dash") and hasDash):
		call_deferred("change_state", State.DASHING)
		
	var wasOnFloor = is_on_floor()
	move_and_slide()
	if (wasOnFloor && !is_on_floor()):
		$CoyoteTimer.start()
	
	if(is_on_floor()):
		hasDash = true
		hasDoubleJump = true
	pass

func process_normal(delta):
	if (isStateNew):
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask
	
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
	pass

func process_Dashing(delta) -> void:
	if (isStateNew):
		hasDash = false
		$DashArea/CollisionShape2D.disabled = false
		$AnimatedSprite2D.play("Jump")
		$HazardArea.collision_mask = DashHazardMask
		var moveVector = _getMovementVector(delta)
		var velocityMod = 1
		if (moveVector != 0):
			velocityMod = sign(moveVector)
		else:
			velocityMod = 1 if $AnimatedSprite2D.flip_h else -1
			
		velocity = Vector2(MaxDashSpeed * velocityMod, 0)
	
	velocity.x = lerp(float(0), velocity.x, pow(2, DashDecay * delta))
	if (abs(velocity.x) < MinDashSpeed):
		call_deferred("change_state", State.NORMAL)
	pass

func _physics_process(delta):
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_Dashing(delta)
			pass
	isStateNew = false
	pass

func change_state(newState):
	currentState = newState
	isStateNew = true


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
			

func on_hazard_area_entered(_a : Area2D) -> void:
	emit_signal("died")
	pass
