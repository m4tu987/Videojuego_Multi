extends Camera2D

@export var move:= false
@export var is_spawning:= true
@export var doors_scenes: Array[PackedScene] = []
@export var box_scenes: Array[PackedScene] = []
var roles = [Statics.Role.ROLE_A,Statics.Role.ROLE_B,Statics.Role.ROLE_C]
var camera_speed = 64
@onready var door_timer = $DoorTimer
@onready var door_positions = $DoorPositions
@onready var doors = $"../Doors"
@onready var box_timer = $BoxTimer
@onready var box_positions = $BoxPositions
@onready var boxes = $"../Boxes"



func _ready():
	if multiplayer.is_server():
		door_timer.timeout.connect(_on_door_timer)
		box_timer.timeout.connect(_on_box_timer_timeout)


func _physics_process(delta):
	if is_multiplayer_authority():
		if move:
			global_position.x += 64*delta

func _on_begin_timeout():
	move = true

func _on_stop_spawning_timeout():
	is_spawning = false 

func _on_stop_timeout():
	move = false


func _on_door_timer():
	if is_spawning:
		var index = randf_range(0,doors_scenes.size()+1)
		if index<doors_scenes.size():
			spawn_door.rpc(index)

@rpc("call_local","authority","reliable")
func spawn_door(door_index):
	var door_scene = doors_scenes[door_index]
	var door_inst = door_scene.instantiate()
	door_inst.global_position = door_positions.global_position
	doors.add_child(door_inst, true)


func _on_box_timer_timeout():
	if is_spawning:
		var index = randf_range(0,box_scenes.size()+1)
		if index<box_scenes.size():
			spawn_box.rpc(index)


@rpc("call_local","authority","reliable")
func spawn_box(box_index):
	var box_scene = box_scenes[box_index]
	var box_inst = box_scene.instantiate()
	box_inst.global_position = box_positions.global_position
	boxes.add_child(box_inst, true)
