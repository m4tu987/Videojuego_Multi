extends MarginContainer
@onready var back_menu = $Panel/MarginContainer/VBoxContainer/Back_menu
@onready var victory_text = $"."

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	back_menu.pressed.connect(_back_menu)

func _back_menu():
	multiplayer.multiplayer_peer.close()
	Game.players = []
	get_tree().paused = false
	victory_text.visible = false
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
