extends MarginContainer
@onready var start = %Start
@onready var credits = %Credits
@onready var exit = %Exit



# Called when the node enters the scene tree for the first time.
func _ready():
	start.pressed.connect(_on_start_pressed)
	credits.pressed.connect(_on_credits_pressed)
	exit.pressed.connect(_on_exit_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/lobby.tscn")
func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/Menus/credits.tscn")
func _on_exit_pressed():
	get_tree().quit()
	
