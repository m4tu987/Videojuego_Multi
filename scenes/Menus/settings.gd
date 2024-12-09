extends MarginContainer

@onready var animation_player = $Parallax2D/Sprite2D/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("new_animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
