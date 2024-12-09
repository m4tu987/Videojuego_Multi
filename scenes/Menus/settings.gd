extends Control

@export var sfx: AudioStream

@onready var animation_player = $Parallax2D/Sprite2D/AnimationPlayer
@onready var music_slider = %MusicSlider
@onready var sfx_slider = %SFXSlider
@onready var back = $back

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("new_animation")
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.drag_ended.connect(_on_sfx_volume_changed)
	back.pressed.connect(_on_back)

func _on_back():
	get_tree().change_scene_to_file("res://scenes/Menus/main_menu.tscn")
func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db(value))
func _on_sfx_volume_changed(value_changed):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(sfx_slider.value))
		AudioManager.play_stream(sfx)
