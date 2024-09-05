extends CharacterBody2D

@export var walking = false
@export var dir = Vector2.ZERO
var speed = 200
var accel = 100
var base_speed = 200
var dash_speed = 1000
var dash_direction = Vector2()
var can_dash = true

@onready var player_tag = $Player_Tag
@onready var animation_tree = $AnimationTree
@onready var sprite_2d = $Sprite2D

var player 

func _physics_process(delta):
	if is_multiplayer_authority():
		var direction = Input.get_vector("left", "right", "up", "down")
		dir = direction.normalized()
		velocity.x = move_toward(velocity.x, speed * dir.x, accel)
		velocity.y = move_toward(velocity.y, speed * dir.y, accel)
		if Input.is_action_just_pressed("dash") and can_dash:
			can_dash = false
			dash_direction = dir
			velocity = dash_direction * dash_speed
			$Dash_Cooldown.start()
		walking = direction != Vector2.ZERO
		send_position.rpc(position)
	if walking:
		animation_tree.set("parameters/Idle/blend_position", dir)
		animation_tree.set("parameters/Walk/blend_position", dir)
	animation_tree["parameters/conditions/Idle"] = !walking
	animation_tree["parameters/conditions/is_walking"] = walking

	move_and_slide()
	
	
	
func setup(player_data):
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id)
	player_tag.text = player_data.name
	player = player_data
	sprite_2d.material.set_shader_parameter("to",getcolor(player_data))

	
@rpc("authority","call_local","unreliable")
func test():
	Debug.log("test %s" % player.name)
	
@rpc("authority","call_remote","unreliable_ordered")
func send_position(pos):
	position = pos


func _on_dash_cooldown_timeout():
	can_dash = true
	
func getcolor(player_data):
	if player_data.role == Statics.Role.ROLE_A:
		return Color.GREEN_YELLOW
	if player_data.role == Statics.Role.ROLE_B:
		return Color.CRIMSON
	if player_data.role == Statics.Role.ROLE_C:
		return Color.ROYAL_BLUE
		
