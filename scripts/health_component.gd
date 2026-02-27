extends Node

signal health_changed(current, max)
signal died

@export var max_health: int = 100 #default Health
var current_health: int

func _ready():
	current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health, max_health)

	if current_health <= 0:
		emit_signal("died")

func heal(amount: int):
	current_health += amount
	current_health = clamp(current_health, 0, max_health)
	emit_signal("health_changed", current_health, max_health)
	
	
func set_max_health(value:int)->void:
	max_health=value;
	current_health=max_health;
	health_changed.emit(current_health, max_health)
	  
func get_current_health()-> int:
	return current_health
