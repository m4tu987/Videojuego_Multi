extends Hitbox

@export var speed = 300
@onready var sprite_2d = $Sprite2D
@export var owner_role: Statics.Role

func _ready():
	if owner_role == Statics.Role.ROLE_A:
		sprite_2d.material.set_shader_parameter("to",Color.LIME)
	if owner_role == Statics.Role.ROLE_B:
		sprite_2d.material.set_shader_parameter("to",Color.CRIMSON)
	if owner_role == Statics.Role.ROLE_C:
		sprite_2d.material.set_shader_parameter("to",Color.BLUE)
	damage_dealt.connect(queue_free)

func _physics_process(delta: float) -> void:
	var velocity = speed * transform.x
	position += velocity * delta
