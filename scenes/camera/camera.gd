extends Camera2D

@export var move:= false
@export var doors_scenes: Array[PackedScene] = []
var roles = [Statics.Role.ROLE_A,Statics.Role.ROLE_B,Statics.Role.ROLE_C]
var camera_speed = 64
@onready var door_timer = $DoorTimer
@onready var doors = $Doors
@onready var door_positions = $DoorPositions


func _ready():
	$Begin.start()
	if multiplayer.is_server():
		door_timer.timeout.connect(_on_door_timer)

func _input(event):
	if event.is_action_pressed("stop"):
		move = !move

func _physics_process(delta):
	if is_multiplayer_authority():
		if move:
			global_position.x += 64*delta

func _on_begin_timeout():
	move = true



func _on_door_timer():
	var door_scene = doors_scenes.pick_random()
	var door_inst = door_scene.instantiate()
	door_inst.global_position = door_positions.global_position
	doors.add_child(door_inst, true)
