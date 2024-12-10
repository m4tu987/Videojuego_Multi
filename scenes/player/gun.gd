class_name Gun
extends Node2D

signal reload_finished

@export var id := 1
@export var bullet_scene: PackedScene
@export var ammo := 30 :
	set(value):
		ammo = value
		if ammo_label:
			ammo_label.text = str(ammo)
@export var max_ammo := 30
@export var max_total_ammo := 90:
	set(value):
		max_total_ammo = value
		if max_ammo_label:
			max_ammo_label.text = str(max_total_ammo)
@onready var marker_2d = $Marker2D
@onready var bullet_spawner = $BulletSpawner
@onready var multiplayer_synchronizer = $MultiplayerSynchronizer
@onready var upward_sprite = $UpwardSprite2D
@onready var canvas_layer = $CanvasLayer
@export var reload_cooldown := 1.5
@export var is_reloading := false
@onready var ammo_label = $CanvasLayer/TextureRect/MarginContainer/HBoxContainer/AmmoLabel
@onready var max_ammo_label = $CanvasLayer/TextureRect/MarginContainer/HBoxContainer/max_ammoLabel
@export var shoot_sound: Array[AudioStream] = []
@export var no_ammo_sound: Array[AudioStream] = []
@export var reload_sound: Array[AudioStream] = []


var can_reload = true
func _ready() -> void:
	setup(id)
	canvas_layer.visible = is_multiplayer_authority()
	ammo = max_ammo
	max_total_ammo = 90
	reload_finished.connect(real_reload)

func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		global_rotation = global_position.direction_to(get_global_mouse_position()).angle()

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	if event.is_action_pressed("fire"):
		fire.rpc_id(1)
		fire_fx.rpc()

func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("reload") and can_reload:
			can_reload = false
			reload.rpc_id(1)
			$reload_timer.start()

func setup(player_id) -> void:
	set_multiplayer_authority(player_id, false)
	multiplayer_synchronizer.set_multiplayer_authority(player_id)

func more_total_ammo_local(extra: int) -> void:
	more_total_ammo.rpc(extra)

@rpc("any_peer", "call_local", "reliable")
func more_total_ammo(extra: int) -> void:
	max_total_ammo += extra

@rpc("reliable", "any_peer", "call_local")
func fire() -> void:
	if not multiplayer.is_server():
		return
	if not bullet_scene:
		Debug.log("No bullet provided")
		return
	if is_reloading:
		return
	if ammo <= 0:
		AudioManager.play_stream(no_ammo_sound.pick_random())
		return
	ammo -= 1
	var bullet_inst = bullet_scene.instantiate()
	bullet_inst.shooter_role = Game.get_player(get_parent().id).role
	bullet_inst.global_position = marker_2d.global_position
	bullet_inst.global_rotation = global_rotation
	bullet_spawner.add_child(bullet_inst, true)

@rpc("reliable", "call_local")
func fire_fx() -> void:
	if ammo <= 0:
		AudioManager.play_stream(no_ammo_sound.pick_random())
	else:
		AudioManager.play_stream(shoot_sound.pick_random())
	var tween = create_tween()
	tween.tween_property(upward_sprite, "position:x", 2, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(upward_sprite, "position:x", 12, 0.15)
	
@rpc("reliable","any_peer","call_local")
func reload() -> void:
	if not multiplayer.is_server():
		return
	is_reloading = true
	reload_fx.rpc()
	
@rpc("any_peer","reliable", "call_local")
func reload_fx() -> void:
	AudioManager.play_stream(reload_sound.pick_random())
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(upward_sprite, "position:y", -4, 0.5)
	tween.tween_property(upward_sprite, "position:y", 10, 0.5)
	tween.tween_property(upward_sprite, "position:y", 0, 0.4)
	await tween.finished
	if multiplayer.is_server():
		reload_finished.emit()
	is_reloading = false
	
func real_reload() -> void:
	var needed_ammo = max_ammo - ammo
	if max_total_ammo >= needed_ammo:
		
		ammo += needed_ammo
		max_total_ammo -= needed_ammo
	else:
		ammo += max_total_ammo
		max_total_ammo = 0 
	if ammo_label:
		ammo_label.text = str(ammo)
	if max_ammo_label:
		max_ammo_label.text = str(max_total_ammo)

func _on_reload_timer_timeout():
	can_reload = true
