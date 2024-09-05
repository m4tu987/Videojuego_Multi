extends CharacterBody2D


var speed = 200
var accel = 100
var base_speed = 200
var dash_speed = 1000
var dash_direction = Vector2()
var can_dash = true

@onready var player_tag = $Player_Tag

var player 

func _input(event):
	if is_multiplayer_authority():
		if event.is_action_pressed("test"):
			test.rpc()
func _physics_process(delta):
	if is_multiplayer_authority():
		var direction = Input.get_vector("left", "right", "up", "down")
		velocity.x = move_toward(velocity.x, speed * direction.x, accel)
		velocity.y = move_toward(velocity.y, speed * direction.y, accel)
		if Input.is_action_just_pressed("dash") and can_dash:
			can_dash = false
			dash_direction = direction.normalized()
			velocity = dash_direction * dash_speed
			$Dash_Cooldown.start()
			
	move_and_slide()
	send_position.rpc(position)
	
	
func setup(player_data):
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id)
	player_tag.text = player_data.name
	player = player_data
	
@rpc("authority","call_local","unreliable")
func test():
	Debug.log("test %s" % player.name)
	
@rpc()	
func send_position(pos):
	position = pos


func _on_dash_cooldown_timeout():
	can_dash = true
