@tool
extends CanvasLayer
@onready var health_bar = $MarginContainer/HealthBar

@export var health := 100 : 
	set(value):
		health = value
		if health_bar:
			health_bar.value = health
