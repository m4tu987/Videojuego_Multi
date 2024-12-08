extends CharacterBody2D

@export var speed = 150
@export var accel = 80

var target: Node2D

@export var is_global := true
@export var death_fx : PackedScene
@export var attack_fx : PackedScene 
@onready var stats := $EnemyStats
@onready var player_detector = $PlayerDetector
@onready var attack_area = $AttackArea
@export var objective = false


func _ready() -> void:
	stats.health_changed.connect(_on_health_changed)
	$SpawnAnimation.play("spawn")
	if is_multiplayer_authority():
		player_detector.body_entered.connect(_on_player_detector_body_entered)
		player_detector.body_exited.connect(_on_player_detector_body_exited)

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
		var direction = (target.global_position - global_position).normalized()
		if (global_position.distance_to(target.global_position) > 60):
			velocity.x = move_toward(velocity.x, direction.x * speed, accel)
			velocity.y = move_toward(velocity.y, direction.y * speed, accel)
		else:
			velocity = Vector2.ZERO
	if velocity == Vector2.ZERO:
		pass
	else:
		$AnimationTree.set("parameters/Walking/blend_position", velocity)
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


@rpc("any_peer", "reliable", "call_local")
func die() -> void:
	if not death_fx:
		pass
	else:
		var death_inst = death_fx.instantiate()
		death_inst.global_position = global_position
		get_parent().add_child(death_inst)
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

@rpc("any_peer","reliable","call_local")
func attack():
	var attack_inst = attack_fx.instantiate()
	attack_inst.global_position = $AttackArea/CollisionShape2D.global_position
	get_parent().add_child(attack_inst)
	attack_area.set_deferred("monitorable", true)
	attack_area.set_deferred("monitoring", true)
	$AttackDuration.start()


func _on_player_detector_body_entered(body):
	var player = body as Player
	if player:
		objective = true
		attack.rpc()

func _on_player_detector_body_exited(body):
	var player = body as Player
	if player:
		objective = true

func _on_attack_duration_timeout():
	attack_area.set_deferred("monitorable", false)
	attack_area.set_deferred("monitoring", false)
	$AttackCooldown.start()

func _on_attack_cooldown_timeout():
	if (objective):
		attack.rpc()
