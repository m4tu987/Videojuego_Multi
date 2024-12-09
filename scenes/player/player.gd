class_name Player
extends CharacterBody2D

signal A_died
signal A_resurrected
signal B_died
signal B_resurrected
signal C_died
signal C_resurrected

@export var id := 1
@export var walking = false
@export var dir = Vector2.ZERO
@export var damage_sound: Array[AudioStream] = []
var speed = 200
var accel = 100
var base_speed = 200
var dash_speed = 1000
var dash_direction = Vector2()
var can_dash = true
var _players_inside: Array[Player] = []
@onready var player_tag = $Player_Tag
@onready var animation_tree = $AnimationTree
@onready var sprite_2d = $Sprite2D
@onready var multiplayer_synchronizer = $MultiplayerSynchronizer
@onready var stats = $Stats
@onready var health_bar = $HealthBar
@onready var hud = $HUD
@onready var playback = animation_tree["parameters/playback"]
@onready var resurrect_area = $ResurrectArea
var dead = 0
@onready var resurrection_timer = $ResurrectionTimer
@onready var resurrection_progress_bar = $ResurrectionProgressBar
const scent_scene = preload("res://scenes/player/scent.tscn")
var scent_trail = []
@onready var scent_timer = $ScentTimer


func _enter_tree() -> void:
	$Gun.id = id


func _ready() -> void:
	setup(id)
	var player_data: Statics.PlayerData = Game.get_player(id)
	sprite_2d.material.set_shader_parameter("to",getcolor(player_data))
	stats.health_changed.connect(_on_health_changed)
	hud.health = stats.health
	health_bar.value = stats.health
	hud.visible = is_multiplayer_authority()
	health_bar.visible = not is_multiplayer_authority()
	player_tag.set_text(player_data.name)
	animation_tree.active = true
	if is_multiplayer_authority():
		resurrect_area.body_entered.connect(_on_dead_player_entered)
		resurrect_area.body_exited.connect(_on_dead_player_exited)
		resurrection_timer.timeout.connect(_on_resurrection_timeout)
	scent_timer.connect("timeout", Callable(self, "add_scent"))
	scent_timer.start()

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	if _players_inside.size():
		if event.is_action_pressed("revivir"):
			resurrection_timer.start()
		if event.is_action_released("revivir"):
			resurrection_timer.stop()
			resurrection_progress_bar.value = 0

func _process(_delta: float) -> void:
	if not resurrection_timer.is_stopped():
		resurrection_progress_bar.value = 1 - (resurrection_timer.time_left / resurrection_timer.wait_time)
		
func _physics_process(_delta: float) -> void:
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
		if stats.health <= 0:
			velocity = Vector2.ZERO
		send_position.rpc(position)
	if walking:
		animation_tree.set("parameters/Idle/blend_position", dir)
		animation_tree.set("parameters/Walk/blend_position", dir)
	animation_tree["parameters/conditions/Idle"] = !walking
	animation_tree["parameters/conditions/is_walking"] = walking
	move_and_slide()
	


func setup(set_id: int) -> void:
	set_multiplayer_authority(set_id, false)
	multiplayer_synchronizer.set_multiplayer_authority(set_id)


@rpc("authority","call_remote","unreliable_ordered")
func send_position(pos):
	position = pos


func _on_dash_cooldown_timeout():
	can_dash = true


func getcolor(player_data):
	if player_data.role == Statics.Role.ROLE_A:
		return Color.DARK_OLIVE_GREEN
	if player_data.role == Statics.Role.ROLE_B:
		return Color.INDIAN_RED
	if player_data.role == Statics.Role.ROLE_C:
		return Color.DARK_SLATE_BLUE

func getcolor2(player_data):
	if player_data.role == Statics.Role.ROLE_A:
		return Color.LIME
	if player_data.role == Statics.Role.ROLE_B:
		return Color.CRIMSON
	if player_data.role == Statics.Role.ROLE_C:
		return Color.BLUE

#se puede tambien hacer notify_take_damage.rpc(get_multiplayer_autorithy(), damage) para que llegue solo al que tiene autoridad
func take_damage(damage: int) -> void:
	if !dead:
		AudioManager.play_stream(damage_sound.pick_random())
	stats.health -= damage

func get_healed_local(heal: int) -> void:
	get_healed.rpc(heal)

@rpc("any_peer", "call_local", "reliable")
func get_healed(heal: int) -> void:
	stats.health += heal

func get_ammo(ammo: int) -> void:
	$Gun.more_total_ammo_local(ammo)

func _on_health_changed(health) -> void:
	hud.health = health
	health_bar.value = health
	if health <= 0:
		die()
	if health > 0:
		playback.travel("Idle")

func die():
	playback.travel("Death")
	dead = 1
	var player_data: Statics.PlayerData = Game.get_player(id)
	if player_data.role == Statics.Role.ROLE_A:
		A_died.emit()
	if player_data.role == Statics.Role.ROLE_B:
		B_died.emit()
	if player_data.role == Statics.Role.ROLE_C:
		C_died.emit()

@rpc("call_local", "reliable", "any_peer")
func resurrect():
	if dead == 1: 
		stats.health = stats.max_health/2
		dead = 0
		var player_data: Statics.PlayerData = Game.get_player(id)
		if player_data.role == Statics.Role.ROLE_A:
			A_resurrected.emit()
		if player_data.role == Statics.Role.ROLE_B:
			B_resurrected.emit()
		if player_data.role == Statics.Role.ROLE_C:
			C_resurrected.emit()

func _on_dead_player_entered(body: Node) -> void:
	if body == self:
		return
	var player = body as Player
	if player:
		if player not in _players_inside:
			_players_inside.push_back(player)

func _on_dead_player_exited(body: Node) -> void:
	if body in _players_inside:
		_players_inside.erase(body)
	if not _players_inside.is_empty():
		resurrection_timer.stop()
		resurrection_progress_bar.value = 0

func _on_resurrection_timeout() -> void:
	for player in _players_inside:
		if is_instance_valid(player):
			player.resurrect.rpc_id(1)
	resurrection_progress_bar.value = 0

func add_scent() -> void:
	if not scent_scene:
		print("Error: scent_scene no está cargada correctamente.")
		return

	# Instanciar la escena correctamente
	var scent = scent_scene.instantiate()  # Utiliza `instantiate` en lugar de `instance`
	if not scent:
		print("Error: No se pudo instanciar la escena scent.")
		return
	
	# Configurar el nodo scent
	scent.player = self
	scent.position = self.position

	# Agregarlo a la escena actual
	if get_tree().current_scene:
		get_tree().current_scene.add_child(scent)
		scent_trail.push_front(scent)
	else:
		print("Error: No se puede añadir a la escena actual.")
