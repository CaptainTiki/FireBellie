extends Camera2D

@export var cameraSmoothing : int = -30
@export var backgroundColor : Color = Color.DARK_GRAY
var targetPosition : Vector2 = Vector2.ZERO

func _ready():
	RenderingServer.set_default_clear_color(backgroundColor)

func _process(delta):
	_aquire_target_position()
	global_position = lerp(targetPosition, global_position, pow(2, cameraSmoothing * delta))

func _aquire_target_position():
	var players = get_tree().get_nodes_in_group("Player")
	if (players.size() > 0):
		var player = players[0]
		targetPosition = player.global_position
		print(player)
