extends Node2D


func _ready():
	$SpawnAnimation.play("Attack")


func _on_timer_timeout():
	queue_free()
