extends MarginContainer

@export var music: AudioStream

@onready var start = %Start
@onready var credits = %Credits
@onready var exit = %Exit
@onready var animation_player = $Parallax2D/Sprite2D/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	MusicManager.play(music)
	if Game.multiplayer_test:
		get_tree().change_scene_to_file.call_deferred("res://scenes/lobby_test.tscn")
		return
	start.pressed.connect(_on_start_pressed)
	credits.pressed.connect(_on_credits_pressed)
	exit.pressed.connect(_on_exit_pressed)
	animation_player.play("new_animation")

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/Menus/credits.tscn")
func _on_exit_pressed():
	get_tree().quit()
	
