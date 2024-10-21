extends Area2D


@export var dead_players:=0
@onready var defeat_text = $"../DefeatText"



func _ready():
	defeat_text.visible = false
	if multiplayer.is_server():
		area_entered.connect(_on_area_entered)
		area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	var dead = area as LoseCondition
	if dead:
		dead_players += 1
		if dead_players == 3:
			defeat.rpc()
	
func _on_area_exited(area: Area2D) -> void:
	var dead = area as LoseCondition
	if dead:
		dead_players -= 1
		if dead_players < 0:
			dead_players = 0


@rpc("call_local","reliable", "any_peer")
func defeat():
	defeat_text.visible = true
	get_tree().paused = true
	
