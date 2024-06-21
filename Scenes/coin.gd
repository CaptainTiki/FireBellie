extends Node2D


func _ready():
	$Area2D.connect("area_entered", on_area_entered)
	pass




func on_area_entered(area2d):
	queue_free()
	pass
