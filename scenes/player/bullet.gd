extends Hitbox

@export var speed = 300

func _ready():
	damage_dealt.connect(queue_free)
func _physics_process(delta: float) -> void:
	var velocity = speed * transform.x
	position += velocity * delta
