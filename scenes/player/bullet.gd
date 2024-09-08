extends Hitbox

@export var speed = 300

func _physics_process(delta: float) -> void:
	var velocity = speed * transform.x
	position += velocity * delta
