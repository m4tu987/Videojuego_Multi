extends Hitbox




func _ready():
	set_damage(1)
	$SpawnAnimation.play("Attack")


func _on_timer_timeout():
	queue_free()
