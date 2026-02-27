extends CharacterBody3D

@onready var target=$"../RootMotionPlayer"
@onready var anim_tree: AnimationTree = $Pomberito_AnimationTree

var speed= 5


var attack_range:=3.5
var attack_cooldown := 2
var can_attack := true

var punch_counter=-1
var punch_counter_max=1
var punch_counter_min=0
var hit= false
var can_get_hit=true;
var already_hit=false
@onready var hitboxL: Area3D = $Pomberito2/metarig_001/Skeleton3D/handL_BoneAttachment3D/Area3D
@onready var hitboxR: Area3D=$Pomberito2/metarig_001/Skeleton3D/handR_BoneAttachment3D/Area3D
@onready var playback = anim_tree.get("parameters/playback")
@onready var healthComponent = $HealthComponent
@onready var health_bar = $EnemyUI/ProgressBar



func _ready():
	anim_tree.animation_finished.connect(_on_animation_finished)
	healthComponent.set_max_health(200);
	healthComponent.health_changed.connect(_on_health_changed);
	# Inicializar UI
	_on_health_changed(healthComponent.current_health, healthComponent.max_health)
	healthComponent.died.connect(_on_died)
	hitboxL.area_entered.connect(_on_hitbox_area_entered)
	hitboxR.area_entered.connect(_on_hitbox_area_entered)
	

func _physics_process(delta: float):
	if !hit :
		var distance = position.distance_to(target.position)
		if distance <= attack_range:
			anim_tree.set_is_running(false)
			anim_tree.set_is_punching(false)
			if can_attack:
				attack()
		else:
			chase(delta)
	else: if can_get_hit:
		anim_tree.set_is_hurt(true)
		can_get_hit=false
		await get_tree().create_timer(0.4).timeout
		anim_tree.set_is_hurt(false)
		await get_tree().create_timer(1).timeout
		can_get_hit=true
		
		
func chase(delta:float):
	anim_tree.set_is_punching(false)
	
	anim_tree.set_is_running(true)

	var direction = (target.position - position).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed  
	  

	look_at(Vector3(target.position.x, position.y, target.position.z))
	move_and_slide()
func take_hit(amount:int):
	healthComponent.take_damage(amount)

	hit=true;
	await get_tree().create_timer(0.2).timeout
	hit =false;
func attack():
	#velocity = Vector3.ZERO
	#move_and_slide()



		anim_tree.set_is_running(false)
		
		can_attack = false
		punch_counter = (punch_counter + 1) % (punch_counter_max + 1)
		anim_tree.set_punch_counter(punch_counter)
		anim_tree.set_is_punching(true)
		
		
		
		await get_tree().create_timer(attack_cooldown).timeout
		can_attack = true
		

func _on_hitbox_area_entered(area):
	print("hitbox_character enter")
	print("ALREADY hit: ", already_hit)
	
	if !already_hit && area.is_in_group("RootMotionPlayer") && (playback.get_current_node() == "golpe_1" || playback.get_current_node()=="golpe_2"):
		var count =0;
		var found= false
		while area != null && !found:
			if area is CharacterBody3D:
				print("is_character enter")
				
				if !area.get_is_blocking():
					print("is_blocking enter")
					count= count+1
					print(count)
					found=true
					already_hit=true
					area.take_damage(10, global_transform.origin)
			area= area.get_parent()
		

func _on_health_changed(current, max):
	health_bar.max_value=max
	health_bar.value = current
func _on_died():
	queue_free()
func _on_animation_finished(anim_name):
	if anim_name == "golpe_2" || anim_name=="golpe_1":
		already_hit = false
		print("already hit ont animation finished: ", already_hit)
