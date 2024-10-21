extends Area2D

@export var winners:= 0
@onready var main = $".."
@onready var victory_text = $"../Camera/VictoryText"



func _ready() -> void:
	victory_text.visible = false
	if multiplayer.is_server():
		area_entered.connect(_on_area_entered)
		



func _on_area_entered(area: Area2D) -> void:
	var winner = area as WinCondition
	if winner:
		winners += 1
		print(winners)
		if winners == 3:
			victory.rpc()

@rpc("call_local","reliable", "any_peer")
func victory():
	victory_text.visible = true
	get_tree().paused = true
	
	
	
	
