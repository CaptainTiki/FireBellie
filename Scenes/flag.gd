extends Node2D

signal player_wins

func _ready():
	$Area2D.connect("area_entered", on_area_entered)


func on_area_entered(_area2d):
	emit_signal("player_wins")
	
