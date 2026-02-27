extends "basic_character_anim_tree.gd"


var punch_counter:int =0;
var is_iddle:bool= false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_is_iddle(delta: float)-> void:
	is_iddle=delta
func set_is_punching(val:bool) -> void:
	is_punching = val;
	#print("Value of is punching in animation tree script ", is_punching)	
func set_is_running(val:bool) -> void:
	is_running = val;
	#print("Value of is punching in animation tree script ", is_running)

	
func set_punch_counter(delta:int) :
	punch_counter=delta;	
func get_punch_counter() -> int :
	return punch_counter;
func get_is_running()-> bool:
	return is_running;
func set_is_hurt(val:bool)->void:
	is_hurt=val;
