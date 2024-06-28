extends Node2D


func _ready():
	$Area2D.connect("area_entered", on_area_entered)
	pass




func on_area_entered(_area2d):
	$AnimationPlayer.play("Pickup")
	call_deferred("disable_pickup")
	pass

func disable_pickup() -> void:
	$Area2D/CollisionShape2D.disabled = true
