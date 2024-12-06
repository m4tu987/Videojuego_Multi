extends Area2D

signal playerAready
signal playerBready
signal playerCready

var player_inside: Player
@export var role: Statics.Role
@onready var animation_screen = $AnimationScreen
@onready var screen_sprite = $ScreenSprite
@onready var hacking_progress_bar = $HackingProgressBar
var activated:= false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	animation_screen.play("Idle")
	if role == Statics.Role.ROLE_A:
		screen_sprite.material.set_shader_parameter("to",Color.LIME)
	if role == Statics.Role.ROLE_B:
		screen_sprite.material.set_shader_parameter("to",Color.CRIMSON)
	if role == Statics.Role.ROLE_C:
		screen_sprite.material.set_shader_parameter("to",Color.BLUE)

func _process(delta: float) -> void:
	if not $HackingTime.is_stopped():
		hacking_progress_bar.value = 1 - ($HackingTime.time_left / $HackingTime.wait_time)

func _input(event: InputEvent) -> void:
	if player_inside:
		if event.is_action_pressed("action") and !activated:
			$HackingTime.start()
		if event.is_action_released("action"):
			$HackingTime.stop()
			hacking_progress_bar.value = 0


func _on_body_entered(body: Node) -> void:
	var player = body as Player
	if player and player.is_multiplayer_authority() and \
		Game.get_player(player.id).role == role:
		player_inside = player

func _on_body_exited(body: Node) -> void:
	if body == player_inside:
		player_inside = null
		$HackingTime.stop()
		hacking_progress_bar.value = 0


func _on_hacking_time_timeout():
	if role == Statics.Role.ROLE_A:
		playerAready.emit()
	if role == Statics.Role.ROLE_B:
		playerBready.emit()
	if role == Statics.Role.ROLE_C:
		playerCready.emit()
	activated = true 
	hacking_progress_bar.value = 0
