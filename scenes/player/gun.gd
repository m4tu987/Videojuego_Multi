extends Node2D

@export var id := 1
@export var bullet_scene: PackedScene
@onready var marker_2d = $Marker2D
@onready var bullet_spawner = $BulletSpawner
@onready var multiplayer_synchronizer = $MultiplayerSynchronizer
@onready var upward_sprite = $UpwardSprite2D


func _ready() -> void:
	setup(id)

func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		global_rotation = global_position.direction_to(get_global_mouse_position()).angle()

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	if event.is_action_pressed("fire"):
		fire.rpc_id(1)
		fire_fx.rpc()

func setup(player_id) -> void:
	set_multiplayer_authority(player_id, false)
	multiplayer_synchronizer.set_multiplayer_authority(player_id)

@rpc("reliable", "any_peer", "call_local")
func fire() -> void:
	if not multiplayer.is_server():
		return
	if not bullet_scene:
		Debug.log("No bullet provided")
		return
	var bullet_inst = bullet_scene.instantiate()
	bullet_inst.shooter_role = Game.get_player(get_parent().id).role
	bullet_inst.global_position = marker_2d.global_position
	bullet_inst.global_rotation = global_rotation
	bullet_spawner.add_child(bullet_inst, true)

@rpc("reliable", "call_local")
func fire_fx() -> void:
	var tween = create_tween()
	tween.tween_property(upward_sprite, "position:x", 2, 0.05).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(upward_sprite, "position:x", 12, 0.15)
