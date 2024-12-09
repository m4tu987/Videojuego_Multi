extends MarginContainer

@onready var animation_player = $"../Parallax2D/Sprite2D/AnimationPlayer"
@onready var button = $PanelContainer/MarginContainer/VBoxContainer/credits/Button


# Called when the node enters the scene tree for the first time.
func _ready():
	button.pressed.connect(_on_back_pressed)
	animation_player.play("new_animation")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
