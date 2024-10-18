class_name EnemyStats
extends Node

signal health_changed(health)

@export var health := 50:
	set(value):
		health = clamp (value, 0, max_health)
		health_changed.emit(health)
@export var max_health := 50
