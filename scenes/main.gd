extends Node2D

@export var player_scene : PackedScene
@onready var markers = $Markers

@export var door_section_scene : PackedScene
@onready var doors = $Doors
var door_colors = [Statics.Role.ROLE_A, Statics.Role.ROLE_B, Statics.Role.ROLE_C]

@onready var defeat_text = $Camera/DefeatText

@export var A_alive = 1 
@export var B_alive = 1
@export var C_alive = 1


func _ready() -> void:
	MusicManager.play_game_music()
	defeat_text.visible = false
	for i in Game.players.size():
		var player_data = Game.players[i]
		var player_inst = player_scene.instantiate()
		player_inst.name = str(player_inst.id)
		player_inst.global_position = markers.get_child(i).global_position
		player_inst.id = player_data.id
		add_child(player_inst, true)
		player_data.local_scene = player_inst
		player_inst.A_died.connect(_on_player_a_died)
		player_inst.B_died.connect(_on_player_b_died)
		player_inst.C_died.connect(_on_player_c_died)
		player_inst.A_resurrected.connect(_on_player_a_resurrected)
		player_inst.B_resurrected.connect(_on_player_b_resurrected)
		player_inst.C_resurrected.connect(_on_player_c_resurrected)
	
#	var index = 0
#	for child in doors.get_children():
#		var door_inst = door_section_scene.instantiate()
#		door_inst.role = door_colors[index] 
#		door_inst.global_position = child.global_position
#		add_child(door_inst, true)
#		index += 1


func _on_player_a_died():
	A_alive = 0
	player_status_changed()

func _on_player_b_died():
	B_alive = 0
	player_status_changed()

func _on_player_c_died():
	C_alive = 0
	player_status_changed()

func _on_player_a_resurrected():
	A_alive = 1
	player_status_changed()

func _on_player_b_resurrected():
	B_alive = 1
	player_status_changed()

func _on_player_c_resurrected():
	C_alive = 1
	player_status_changed()

func player_status_changed():
	if !A_alive and !B_alive and !C_alive:
		Defeat.rpc()
		

@rpc("call_local","reliable","any_peer")
func Defeat():
	defeat_text.visible = true
	get_tree().paused = true
