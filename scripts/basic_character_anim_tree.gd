extends AnimationTree

var is_running:bool = false;
var is_punching:bool =false;
var is_hurt:bool= false
func set_is_punching(val:bool) -> void:
	is_punching = val;
	#print("Value of is punching in animation tree script ", is_punching)	
func set_is_running(val:bool) -> void:
	is_running = val;
	#print("Value of is punching in animation tree script ", is_running)
func set_is_hurt(val:bool)->void:
	is_hurt=val;
