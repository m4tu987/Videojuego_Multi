class_name Door
extends Node2D

@onready var animation_door = $AnimationDoor

func open() -> void:
	open_local.rpc()

@rpc("any_peer", "reliable", "call_local")
func open_local() -> void:
	animation_door.play("turnOff")

func _ready():
	animation_door.play("ray")

	
	
