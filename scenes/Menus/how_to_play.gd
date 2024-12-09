extends MarginContainer
@onready var animation_player = $Parallax2D/Sprite2D/AnimationPlayer
@onready var back_menu = $PanelContainer/MarginContainer/VBoxContainer/back_menu


# Called when the node enters the scene tree for the first time.
func _ready():
	back_menu.pressed.connect(_back_menu)
	animation_player.play("new_animation")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _back_menu():
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
