extends Node2D

@export var bullet_scene: PackedScene
@onready var marker_2d = $Marker2D


func fire() -> void:
	if not bullet_scene:
		Debug.log("No bullet provided")
		return
	var bullet_inst = bullet_scene.instantiate()
	get_parent().add_child(bullet_inst)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
