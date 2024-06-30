extends CharacterBody2D

enum Direction {RIGHT, LEFT}
@export var startDirection : Direction = Direction.RIGHT

var direction = Vector2.ZERO
var maxSpeed = 25
var gravity = 500
var direct = Vector2.ZERO

func _ready() -> void:
	direction = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	$GoalDetector.connect("area_entered", on_goal_entered)

func _process(_delta: float) -> void:
	$AnimatedSprite2D.flip_h = true if direction.x > 0 else false
	move_and_slide()


func _physics_process(delta: float) -> void:
	velocity.x = direction.x * maxSpeed
	velocity.y += gravity * delta

func on_goal_entered(_area2D)-> void:
	direction *= -1
	pass
