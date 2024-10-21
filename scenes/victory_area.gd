extends Area2D

@export var winners:= 0
@export var win:= false
@onready var victory_text = $"../VictoryText"



func _ready() -> void:
	if multiplayer.is_server():
		area_entered.connect(_on_area_entered)
		

func _process(delta):
	print(win)
	victory_text.visible = win

func _on_area_entered(area: Area2D) -> void:
	var winner = area as WinCondition
	if winner:
		winners += 1
		print(winners)
		if winners == 3:
			victory()


func victory():
	print("AAAAAAAAAAAAAAAAA")
	win = true
	
	
	
