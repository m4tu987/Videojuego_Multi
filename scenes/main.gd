extends Node2D

@export var player_scene : PackedScene
@onready var Players = $Players
@onready var markers = $Markers

func _ready() -> void:
	for i in Game.players.size():
		var player_data = Game.players[i]
		var player_inst = player_scene.instantiate()
		player_inst.name = str(player_inst.id)
		player_inst.global_position = markers.get_child(i).global_position
		player_inst.id = player_data.id
		add_child(player_inst, true)
		player_data.local_scene = player_inst
