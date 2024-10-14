class_name Door
extends Node2D



@onready var animation_door = $AnimationDoor
@export var role: Statics.Role
@onready var ray_sprite = $Ray/Parallax2D/raySprite

func open() -> void:
	open_local.rpc()

@rpc("any_peer", "reliable", "call_local")
func open_local() -> void:
	animation_door.play("turnOff")

func _ready():
	animation_door.play("ray")
	if role == Statics.Role.ROLE_A:
		ray_sprite.material.set_shader_parameter("to",Color.LIME)
	if role == Statics.Role.ROLE_B:
		ray_sprite.material.set_shader_parameter("to",Color.CRIMSON)
	if role == Statics.Role.ROLE_C:
		ray_sprite.material.set_shader_parameter("to",Color.BLUE)
