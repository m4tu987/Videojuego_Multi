extends Hitbox

@export var attack_sound: Array[AudioStream] = []


func _ready():
	set_damage(5)
	AudioManager.play_stream(attack_sound.pick_random())
	$SpawnAnimation.play("Attack")


func _on_timer_timeout():
	queue_free()
