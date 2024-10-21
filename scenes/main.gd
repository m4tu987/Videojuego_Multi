extends Node2D

signal win
@onready var victory_text = $Camera/VictoryText

@export var player_scene : PackedScene
@onready var markers = $Markers

@export var door_section_scene : PackedScene
@onready var doors = $Doors
var door_colors = [Statics.Role.ROLE_A, Statics.Role.ROLE_B, Statics.Role.ROLE_C]

func _ready() -> void:
	for i in Game.players.size():
		var player_data = Game.players[i]
		var player_inst = player_scene.instantiate()
		player_inst.name = str(player_inst.id)
		player_inst.global_position = markers.get_child(i).global_position
		player_inst.id = player_data.id
		add_child(player_inst, true)
		player_data.local_scene = player_inst
	
	var index = 0
	for child in doors.get_children():
		var door_inst = door_section_scene.instantiate()
		door_inst.role = door_colors[index] 
		door_inst.global_position = child.global_position
		add_child(door_inst, true)
		index += 1
	victory_text.visible = false
	win.connect(victory_display)

@rpc("call_remote","reliable","authority")
func victory_display():
	victory_text.visible = true
