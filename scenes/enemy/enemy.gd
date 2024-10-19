extends CharacterBody2D

@export var speed = 100
@export var accel = 50
@export var base_speed = 50

var target: Node2D

@export var is_global := true

@onready var stats := $EnemyStats

func _ready() -> void:
	stats.health_changed.connect(_on_health_changed)

func _physics_process(_delta: float) -> void:
	if is_global:
		var closest = null
		var closest_distance_squared = 0
		for player in Game.players:
			var player_distance_squared = (player.local_scene.global_position - global_position).length_squared()
			if not closest or player_distance_squared < closest_distance_squared:
				closest = player.local_scene
				closest_distance_squared = player_distance_squared
		target = closest
	if target:
		var direction = sign(target.global_position - global_position)
		velocity.x = move_toward(velocity.x, direction.x * speed, accel)
		velocity.y = move_toward(velocity.y, direction.y * speed, accel)
	move_and_slide()
	
func _on_body_entered(body: Node) -> void:
	var player = body as Player
	if player:
		set_target(player)


func _on_body_exited(body: Node) -> void:
	if body == target:
		set_target(null)

func take_damage(damage: int) -> void:
		stats.health -= damage
		if stats.health <=0:
			queue_free()


func _on_health_changed(health) -> void:
	if health<=0:
		die.rpc()


@rpc("any_peer", "reliable")
func die() -> void:
	queue_free()


func set_target(value: Node2D) -> void:
	target = value
	var path = null
	if target:
		target.get_path()  
	set_target_remote.rpc(path)

@rpc("any_peer", "reliable")
func set_target_remote(target_path):
	if target_path:
		target = get_node(target_path)
	else:
		target = null
