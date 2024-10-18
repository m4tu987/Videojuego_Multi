class_name Bullet
extends Hitbox


@export var speed = 300
@export var shooter_role: Statics.Role

@onready var sprite_2d = $Sprite2D



func _ready():
	set_damage(10)
	var bullet_color = get_color(shooter_role)
	sprite_2d.material.set_shader_parameter("to",bullet_color)
	damage_dealt.connect(queue_free)

func _physics_process(delta: float) -> void:
	var velocity = speed * transform.x
	position += velocity * delta
	
func get_color(role: Statics.Role) -> Color:
	if role == Statics.Role.ROLE_A:
		return Color.LIME
	if role == Statics.Role.ROLE_B:
		return Color.CRIMSON
	if role == Statics.Role.ROLE_C:
		return Color.BLUE
	else: 
		return Color.DIM_GRAY
