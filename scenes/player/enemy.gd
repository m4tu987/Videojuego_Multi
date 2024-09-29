extends CharacterBody2D

var speed = 200
var accel = 100
var base_speed = 200

var target: Node2D

@onready var detection_area: Area2D = $DetectionArea

func _ready() -> void:
	if multiplayer.is_server():
		detection_area.body_entered.connect(_on_body_entered)
		detection_area.body_exited.connect(_on_body_exited)

func _physics_process(delta: float) -> void:
	if target:
		var direction = sign(target.global_position - global_position)
		velocity.x = move_toward(velocity.x, direction.x * speed, accel)
		velocity.y = move_toward(velocity.y, direction.y * speed, accel)
	move_and_slide()
	
func _on_body_entered(body: Node) -> void:
	var playerd = body as Player
	if playerd:
		set_target(playerd)


func _on_body_exited(body: Node) -> void:
	if body == target:
		set_target(null)


func set_target(value: Node2D) -> void:
	target = value
