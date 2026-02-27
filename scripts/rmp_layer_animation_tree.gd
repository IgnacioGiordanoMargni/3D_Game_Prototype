extends "basic_character_anim_tree.gd"


var is_moving:bool =false;

var is_p_l:bool = false;
var is_p_r:bool= false;
var is_blocking:bool =false;
var is_striding_r:bool =false;
var is_striding_l: bool= false;

var punch_counter:int=0
var is_jumping:bool=false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_is_moving(val:bool) -> void:
	is_moving = val;
	#print("Value of is moving in animation tree script ", is_moving)
	
func set_is_punching(val:bool) -> void:
	is_punching = val

	if is_punching:
		if punch_counter%2==0:
			punch_counter=punch_counter+1;
			is_p_l=true
		else:
			punch_counter=punch_counter+1;
			is_p_r=true
	else :
		is_p_l=false
		is_p_r=false 
	#print (" punch counter: ", punch_counter, " |is_p_l: ", is_p_l, " |os_p_r: ", is_p_r, " |is_punching: ", is_punching)	

	
	#print("Value of is punching in animation tree script ", is_punching)	

func set_is_blocking(val:bool) -> void:
	is_blocking = val;
	#print("Value of is punching in animation tree script ", is_running)
func set_striding_l(val:bool) -> void:
	is_striding_l = val;
func set_striding_r(val:bool) -> void:
	is_striding_r = val;	
func set_is_jumping(val:bool) -> void:
	is_jumping = val;	
func get_is_jumping()-> bool:
	return is_jumping;
