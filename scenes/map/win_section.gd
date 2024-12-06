extends Node2D



@onready var screen_win_a = $ScreenWinA
@onready var screen_win_b = $ScreenWinB
@onready var screen_win_c = $ScreenWinC

@onready var main = $".."
@onready var victory_text = $"../Camera/VictoryText"

@export var A_condition = 0 
@export var B_condition = 0
@export var C_condition = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	victory_text.visible = false
	screen_win_a.playerAready.connect(Aready)
	screen_win_b.playerBready.connect(Bready)
	screen_win_c.playerCready.connect(Cready)
	if multiplayer.is_server():
		if A_condition and B_condition and C_condition:
			victory.rpc()

func Aready():
	AreadyServer.rpc_id(1)

@rpc("call_local","any_peer","reliable")
func AreadyServer():
	A_condition = 1
	on_condition_change()

func Bready():
	BreadyServer.rpc_id(1)

@rpc("call_local","any_peer","reliable")
func BreadyServer():
	B_condition = 1
	on_condition_change()


func Cready():
	CreadyServer.rpc_id(1)

@rpc("call_local","any_peer","reliable")
func CreadyServer():
	C_condition = 1
	on_condition_change()


@rpc("call_local", "reliable", "any_peer")
func on_condition_change():
	if A_condition == 1 and B_condition == 1 and C_condition == 1:
		victory.rpc()


@rpc("call_local","reliable","any_peer")
func victory():
	victory_text.visible = true
	get_tree().paused = true
