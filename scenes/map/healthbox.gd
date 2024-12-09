extends StaticBody2D

@export var role: Statics.Role 
var activated:= false
@onready var simbol = $Simbol
@onready var activation_area = $ActivationArea
@onready var healing_area = $HealingArea
var player_inside: Player
var player_list = []
@onready var activation_progress_bar = $ActivationProgressBar


func _ready():
	activation_area.body_entered.connect(_on_body_entered)
	activation_area.body_exited.connect(_on_body_exited)
	healing_area.body_entered.connect(_healing_list)
	$AnimationPlayer.play("animation")
	if role == Statics.Role.ROLE_A:
		simbol.material.set_shader_parameter("to",Color.LIME)
	if role == Statics.Role.ROLE_B:
		simbol.material.set_shader_parameter("to",Color.CRIMSON)
	if role == Statics.Role.ROLE_C:
		simbol.material.set_shader_parameter("to",Color.BLUE)

func _process(_delta: float) -> void:
	if not $ActivationTimer.is_stopped():
		activation_progress_bar.value = 1 - ($ActivationTimer.time_left / $ActivationTimer.wait_time)

func _input(event: InputEvent) -> void:
	if player_inside:
		if event.is_action_pressed("action") and !activated:
			$ActivationTimer.start()
		if event.is_action_released("action"):
			$ActivationTimer.stop()
			activation_progress_bar.value = 0

func _on_body_entered(body: Node) -> void:
	var player = body as Player
	if player and player.is_multiplayer_authority() and \
		Game.get_player(player.id).role == role:
		player_inside = player


func _on_body_exited(body: Node) -> void:
	if body == player_inside:
		player_inside = null
		$ActivationTimer.stop()
		activation_progress_bar.value = 0

func _healing_list(body: Node) -> void:
	var player = body as Player
	if player:
		player_list.append(player)

func _on_activation_timer_timeout():
	activated = true 
	activation_progress_bar.value = 0
	activation_area.set_deferred("monitoring",false)
	heal_players()

func heal_players():
	Debug.log("CONGRATULACIONES")
	for player in player_list:
		player.get_healed_local(50)


func _on_timer_timeout():
	healing_area.set_deferred("monitoring",true)
