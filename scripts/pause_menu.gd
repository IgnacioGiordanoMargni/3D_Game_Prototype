extends Control

func _on_reanudar_pressed():
	get_tree().paused = false
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_reiniciar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_salir_pressed():
	get_tree().quit()
