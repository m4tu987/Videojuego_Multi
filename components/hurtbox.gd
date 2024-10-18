class_name Hurtbox
extends Area2D


@export var self_damage = false
@export var is_inside = false
@export var current_damage:= 0


func _ready() -> void:
	if multiplayer.is_server():
		area_entered.connect(_on_area_entered)
		area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox:
		var bullet = hitbox as Bullet
		if bullet:
			if !self_damage and bullet.shooter_role == Game.get_player(owner.id).role:
				return
		is_inside = true
		if owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
			hitbox.damage_dealt.emit()
		var hitzone = hitbox as Hitzone
		if hitzone:
			current_damage = hitzone.damage
			$ReDamage.start()


func _on_area_exited(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox:
		is_inside = false
		current_damage = 0


func _on_re_damage_timeout():
	if is_inside == true:
		if owner.has_method("take_damage"):
			owner.take_damage(current_damage)
			$ReDamage.start()
