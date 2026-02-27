extends Node3D

var player_inside = false
var is_open=false;
func _on_area_3d_body_entered(body):
	if body.name == "Player":
		player_inside = true

func _on_area_3d_body_exited(body):
	if body.name == "Player":
		player_inside = false

func interact():
	if is_open:
		$AnimationPlayer.play("close")
	else:
		$AnimationPlayer.play("open")
