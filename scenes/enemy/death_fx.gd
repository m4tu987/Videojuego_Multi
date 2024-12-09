extends Node2D

@export var death_sound: Array[AudioStream] = []


func _ready():
	AudioManager.play_stream(death_sound.pick_random())
	$SpawnAnimation.play("Death")


func _on_timer_timeout():
	queue_free()
