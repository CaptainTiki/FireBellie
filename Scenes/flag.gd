extends Node2D

func _ready():
	$Area2D.connect("area_entered", on_area_entered)


func on_area_entered(_area2d):
	print("win!")
	
