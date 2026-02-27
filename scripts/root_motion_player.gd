extends CharacterBody3D

@export var rotation_speed := 7.0
var sensibilidad := 0.7
@onready var anim_tree: AnimationTree = $RMPLayerAnimationTree2
var velocity_percentile= 1.50
@onready var cam = $Pivote

var dmg= 10

#state boolean variables
var is_punching=false	
var is_blocking=false;
var can_get_hit=true;
@onready var hitboxR:Area3D = $Player_head_new_animationsglb/full_body/Skeleton3D/handL_hitbox/Area3D
@onready var hitboxl:Area3D = $Player_head_new_animationsglb/full_body/Skeleton3D/handR_hitbox/Area3D
@onready var pause_menu =$"../PauseMenu"
@onready var death_menu =  $"../deadMenu"



@onready var healthComponent = $HealthComponent
@onready var health_bar = $UI/HealthBar

@export var knockback_resistance: float = 1.0
var knockback_direction: Vector3 = Vector3.ZERO
var knockback_force: float = 0.0
var is_knocked_back: bool = false

var state_machine

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


var current_interactable = null

var input_method_map = {
	"move_forward": "set_is_running",
	"move_back": "set_is_moving_back",
	"stride_left": "set_striding_l",
	"stride_right": "set_striding_r",
	"jump": "set_is_jumping",
	"punch":"set_is_punching",
	"block":"set_is_blocking"
}
func _ready():
	healthComponent.health_changed.connect(_on_health_changed);
	# Inicializar UI
	_on_health_changed(healthComponent.current_health, healthComponent.max_health)
	healthComponent.died.connect(_on_died)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	anim_tree.active = true
	hitboxR.body_entered.connect(_on_hitbox_body_entered)
	hitboxl.body_entered.connect(_on_hitbox_body_entered)
func _physics_process(delta):
	
	if is_knocked_back:
		# Aplica el knockback al movimiento
		var knockback_velocity = knockback_direction * knockback_force * delta
		move_and_slide()
		
		# Reduce el knockback con el tiempo (resistencia)
		knockback_force = knockback_force * (1.0 - knockback_resistance * delta)
		if knockback_force < 1.0:
			is_knocked_back = false
			knockback_force = 0.0
	else:
		#print(is_on_floor())
		if not is_on_floor() && !anim_tree.get_is_jumping():
			velocity.y -= gravity * delta
		else :
			handle_movement(delta)

			var root_motion = anim_tree.get_root_motion_position()
			apply_root_motion(delta, root_motion)

		move_and_slide()

func handle_movement(delta):
	update_animation_methods()
	if current_interactable and Input.is_action_just_pressed("interact"):
		print("interact")
		current_interactable.interact()
	#if Input.is_action_just_pressed("jump") && !is_punching :
	#
		#handle_jump();
	

func get_is_blocking()->bool:
	return is_blocking;
func handle_jump()-> void:
	can_get_hit=false;
	anim_tree.set_is_jumping(true)
	await get_tree().create_timer(1).timeout
	anim_tree.set_is_jumping(false)
	can_get_hit=true;
	
	
func handle_block()->void:
	is_blocking=true
	anim_tree.set_is_blocking(is_blocking)
	
func handle_punch()-> void:

	anim_tree.set_is_punching(is_punching)
	await get_tree().create_timer(0.5).timeout
	is_punching=false
	anim_tree.set_is_punching(is_punching)
	
	

func rotate_towards(direction: Vector3, delta):
	var target_angle = atan2(-direction.x, -direction.z)
	rotation.y = lerp_angle(rotation.y, target_angle, delta * rotation_speed)

func _input(event: InputEvent)-> void:
	#if event is InputEventMouseMotion:
		#rotate_y(deg_to_rad(-event.relative.y * sensibilidad))
		#rotate_x(deg_to_rad(-event.relative.x * sensibilidad))
		#rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(45))
	if event.is_action_pressed("pause"):
		toggle_pause()
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sensibilidad))
		cam.rotate_x(deg_to_rad(-event.relative.y * sensibilidad) * 0.40)
		cam.rotation.x = clamp(
		cam.rotation.x,
		deg_to_rad(-45),
		deg_to_rad(45)
		)
func apply_root_motion(delta: float, root_motion: Vector3) -> void:

	var local_motion = Vector3(
		root_motion.x,
		root_motion.y,
		root_motion.z   
	)
	#print("root motion x: ", root_motion.x," root_motion.y : ", root_motion.y, " root_motion.z : ", root_motion.z)
	#if anim_tree.get_is_jumping():
		#print(gravity)
		#local_motion.y=local_motion.y+gravity*delta*0.60
	var world_motion = global_transform.basis * local_motion * velocity_percentile

	velocity.x = world_motion.x / delta
	velocity.z = world_motion.z / delta
	velocity.y = world_motion.y/ delta
func take_damage(amount: int, hit_position: Vector3):
	anim_tree.set_is_hurt(true)
	await get_tree().create_timer(0.5).timeout
	anim_tree.set_is_hurt(false)
	healthComponent.take_damage(amount)
	print("Salud: ", healthComponent.get_current_health())
	
	
func apply_knockback(hit_position: Vector3):
	var direction = (global_transform.origin - hit_position).normalized()
	
	var force = 4.0
	velocity += direction * force
func _on_hitbox_body_entered(body):
	if body.is_in_group("Pomberito") :
		body.take_hit(dmg)
		
		


func toggle_pause():
	get_tree().paused = !get_tree().paused
	pause_menu.visible = get_tree().paused
	
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
func _on_died():
	print("El jugador murió")
	get_tree().paused = !get_tree().paused
	death_menu.visible=get_tree().paused
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
func _on_health_changed(current, max):
	health_bar.max_value=max
	health_bar.value = current


func _on_interaction_area_body_entered(body):
	print("on enter")
	if body.has_method("interact"):
		current_interactable = body

func _on_interaction_area_body_exited(body):
	if body == current_interactable:
		current_interactable = null
	
	
func update_animation_methods():
	for action in input_method_map.keys():
		var method_name = input_method_map[action]
		var action_pressed = Input.is_action_pressed(action)
		var action_just_pressed= Input.is_action_pressed(action)
		if action_just_pressed:
			if anim_tree.has_method(method_name):
				anim_tree.call(method_name, action_just_pressed)
		else : 
			if !action_pressed :
				if anim_tree.has_method(method_name):
					anim_tree.call(method_name, action_just_pressed)
