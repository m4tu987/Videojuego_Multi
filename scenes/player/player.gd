extends CharacterBody2D


var speed = 400.0
var acceleration = 300
var dash_speed = 300
var gravity = 400

@onready var nombre_personaje = $Nombre_personaje

var player 

func _input(event):
	if is_multiplayer_authority():
		if event.is_action_pressed("test"):
			test.rpc()
func _physics_process(delta):
	if is_multiplayer_authority():
		var move_input = Input.get_axis("move_left","move_right")
		velocity.x = move_toward(velocity.x, speed * move_input, acceleration * delta)
		var move_input2 = Input.get_axis("move_up","move_down")
		velocity.y = move_toward(velocity.y, speed * move_input2, acceleration * delta)
		if Input.is_action_just_pressed("dash"):
			velocity.x = (dash_speed * velocity.x)/100
	move_and_slide()
	send_position.rpc(position)
	
func setup(player_data):
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id)
	nombre_personaje.text = player_data.name
	player = player_data
	
@rpc("authority","call_local","unreliable")
func test():
	Debug.log("test %s" % player.name)
	
@rpc()	
func send_position(pos):
	position = pos
	
	
