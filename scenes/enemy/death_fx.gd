extends Node2D



func _ready():
	$SpawnAnimation.play("Death")


func _on_timer_timeout():
	queue_free()
