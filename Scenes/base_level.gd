extends Node

var playerScene = preload("res://Scenes/player.tscn")
var spawnPosition = Vector2.ZERO
var currentPlayerNode = null

func _ready() -> void:
	spawnPosition = $Player.global_position
	register_player($Player)

#listen to player death
func register_player(player):
	currentPlayerNode = player
	currentPlayerNode.connect("died", on_player_died, CONNECT_DEFERRED)
	pass

#
func create_player():
	var playerInstance = playerScene.instantiate()
	find_child("PlayerSpawn").add_child(playerInstance)
	playerInstance.global_position = spawnPosition
	register_player(playerInstance)
	pass

func on_player_died() -> void:
	currentPlayerNode.queue_free()
	create_player()
	pass
