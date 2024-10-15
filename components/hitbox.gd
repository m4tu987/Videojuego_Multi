class_name Hitbox
extends Area2D

signal damage_dealt

@export var damage : int

func set_damage(child_damage : int) -> void:
	damage = child_damage
