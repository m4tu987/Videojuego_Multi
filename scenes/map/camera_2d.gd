extends Camera2D


func _physics_process(delta):
	if Input.is_action_pressed("left"):
		position.x -= 300*delta
	if Input.is_action_pressed("right"):
		position.x += 300*delta
