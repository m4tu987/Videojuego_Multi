extends Node2D

@export var player_scene : PackedScene
@onready var Players = $Players

func _ready() -> void:
	for player_data in Game.players:
		var player_inst = player_scene.instantiate()
		Players.add_child(player_inst)
		player_inst.setup(player_data)
