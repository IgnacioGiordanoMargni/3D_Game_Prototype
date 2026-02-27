extends Node

@export var max_health := 100
var current_health := 0

signal died
signal damaged(amount)

func _ready():
	current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	emit_signal("damaged", amount)

	if current_health <= 0:
		current_health = 0
		emit_signal("died")
