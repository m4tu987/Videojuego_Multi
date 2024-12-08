extends Hitbox




func _ready():
	set_damage(5)
	$SpawnAnimation.play("Attack")


func _on_timer_timeout():
	queue_free()
