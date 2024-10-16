class_name Hitbox
extends Area2D

signal damage_dealt


@export var damage : int
#@export var dealer: Player

func set_damage(child_damage : int) -> void:
	damage = child_damage
	
#func set_dealer(player: Player) -> void:
#	dealer = player
