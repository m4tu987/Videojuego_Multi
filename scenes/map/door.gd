class_name Door
extends Node2D

@onready var animation_door = $AnimationDoor
@export var role: Statics.Role
@onready var ray_sprite = $Ray/Parallax2D/raySprite
@onready var ray_collision_shape = $Ray/RayCollisionShape
@onready var ray_hitbox_shape = $Hitbox/RayHitboxShape



func open() -> void:
	open_local.rpc()


@rpc("any_peer", "reliable", "call_local")
func open_local() -> void:
	animation_door.play("turnOff")
	$TurningOff.start()


func _ready():
	role = get_parent().role
	if role == Statics.Role.ROLE_A:
		ray_sprite.material.set_shader_parameter("to",Color.LIME)
	if role == Statics.Role.ROLE_B:
		ray_sprite.material.set_shader_parameter("to",Color.CRIMSON)
	if role == Statics.Role.ROLE_C:
		ray_sprite.material.set_shader_parameter("to",Color.BLUE)
	animation_door.play("ray")


func _on_turning_off_timeout():
	ray_sprite.visible = false
	ray_collision_shape.disabled = true
	ray_hitbox_shape.disabled = true
