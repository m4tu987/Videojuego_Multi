extends Camera2D

@export var move:= false

func _ready():
	$Begin.start()

func _input(event):
	if event.is_action_pressed("stop"):
		move = !move

func _physics_process(delta):
	if is_multiplayer_authority():
		if move:
			position.x += 50*delta

func _on_begin_timeout():
	move = true
