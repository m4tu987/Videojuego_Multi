extends MarginContainer
@export var lobby_player_scene: PackedScene
@onready var back_to_menu = $Panel/MarginContainer/VBoxContainer/Back_to_menu
@onready var defeat_text = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	back_to_menu.pressed.connect(_back_to_menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _back_to_menu():
	multiplayer.multiplayer_peer.close()
	Game.players = []
	get_tree().paused = false
	defeat_text.visible = false
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
	
