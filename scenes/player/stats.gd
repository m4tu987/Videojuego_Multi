class_name Stats
extends Node

signal health_changed(health)

@export var health := 100:
	set(value):
		var last_health = health
		health = clamp (value, 0, max_health)
		if (health != last_health):
			health_changed.emit(health)
@export var max_health := 100
# Called when the node enters the scene tree for the first time.
