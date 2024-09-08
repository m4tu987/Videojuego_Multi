extends Node2D

@export var bullet_scene: PackedScene
@onready var marker_2d = $Marker2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		fire()
	


func fire() -> void:
	if not bullet_scene:
		Debug.log("No bullet provided")
		return
	var bullet_inst = bullet_scene.instantiate()
	get_parent().add_child(bullet_inst)
	bullet_inst.global_position = marker_2d.global_position
	bullet_inst.global_rotation	= global_rotation
