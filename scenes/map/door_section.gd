extends Node2D

@export var role: Statics.Role


func _on_despawn_timeout():
	queue_free()
