extends CharacterBody2D

# TODO:
#
#If both R and L Mouse are clicked at the same time they overlap and allow you to shoot and not reload
#Maybe add in the slide to stop on the stab, dont let players turn around while stabbing
#Can't go back to previous level
#
#
#
#


# If player should be enabled
@export var enable_player : bool:
	set(value):
		enable_player = value
		$AnimationTree.active = true
	get:
		return enable_player

# Movement Speed
var speed := 125.0
var reloading_movement_speed := 40.0
var acceleration := 1.0
var sprinting := false

# More predictable jumps
var jump_height : float = 50.0
var jump_time_to_peak : float = 0.5
var jump_time_to_descent : float = 0.4
@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

# For variable jump height
var cut_height : float = 0.75

# Max y velocity
var max_fall_velocity : float = 350

# Jumping variables
#var can_jump := false
#var jump_was_pressed := false
#var is_jumping := false

# Corner Correction variables
#@onready var cc_outer_left := $Corner_Correction_Raycasts/Outer_Left
#@onready var cc_inner_left := $Corner_Correction_Raycasts/Inner_Left
#@onready var cc_outer_right := $Corner_Correction_Raycasts/Outer_Right
#@onready var cc_inner_right := $Corner_Correction_Raycasts/Inner_Right
#var cc_push_amount := 3.0
#
# Stair Check variables
@onready var sc_head_left := $Stair_Check_Raycasts/Head_Left
@onready var sc_ground_left := $Stair_Check_Raycasts/Ground_Left
@onready var sc_head_right := $Stair_Check_Raycasts/Head_Right
@onready var sc_ground_right := $Stair_Check_Raycasts/Ground_Right
var sc_push_amount := 8.0

# Animation variables
@onready var anim_tree := $AnimationTree
@onready var anim_player := $AnimationPlayer
var facing := 1 # 0 is left, 1 is right

# Attacking variables
@onready var sprite := $Sprite2D
@export var attacking := false
@export var reloading := false
@export var shooting := false
@export var stabbing := false
@export var crouching := false

@onready var gun_tip := $Gun_Tip

# Sound variables
@onready var primary_audio := $Audio/PrimaryAudio
@onready var secondary_audio := $Audio/SecondaryAudio
@onready var footstep_audio := $Audio/Footsteps
@onready var hurt_audio := $Audio/HurtAudio

func _ready():
	GameManager.player = self
	$Gun_Tip/Attack_Box/CollisionShape2D.disabled = true
	anim_tree.set("parameters/ground/transition_request", "idle")

func _physics_process(delta):
	
	if enable_player:
		# Handle general input
		get_input()

		# Handle Jump
		handle_jump(delta)
			
		# Horizontal Movement
		horizontal_movement()
		
		# Adjust animation tree based on horizontal movement
		anim_tree_transition_requests()

	#	# Corner Correction
	#	corner_correction()
	
		# Audio
		audio()
	#
	#	# Stair Check
		stair_check()
		
		GameManager.player = self

		move_and_slide()

func anim_tree_transition_requests():
	if velocity.x != 0 and !attacking and !reloading and !crouching:
		if velocity.x < 0:
			facing = 0
			gun_tip.position.x = -31.0
			anim_tree.set("parameters/running/transition_request", "run_left")
			anim_tree.set("parameters/ground/transition_request", "running")
			anim_tree.set("parameters/jumping/transition_request", "jump_left")
			anim_tree.set("parameters/falling/transition_request", "fall_left")
		elif velocity.x > 0:
			facing = 1
			gun_tip.position.x = 31.0
			anim_tree.set("parameters/running/transition_request", "run_right")
			anim_tree.set("parameters/ground/transition_request", "running")
			anim_tree.set("parameters/jumping/transition_request", "jump_right")
			anim_tree.set("parameters/falling/transition_request", "fall_right")
	elif !attacking and reloading and !crouching:
		var anim_pos = 0.0
		anim_tree.set("parameters/ground/transition_request", "reloading")
		if velocity.x != 0:
			if velocity.x < 0:
				facing = 0
				gun_tip.position.x = -21.0
				sprite.flip_h = true
				anim_tree.set("parameters/running/transition_request", "run_left")
				anim_tree.set("parameters/jumping/transition_request", "jump_left")
				anim_tree.set("parameters/falling/transition_request", "fall_left")
			else:
				facing = 1
				gun_tip.position.x = 21.0
				sprite.flip_h = false
				anim_tree.set("parameters/running/transition_request", "run_right")
				anim_tree.set("parameters/jumping/transition_request", "jump_right")
				anim_tree.set("parameters/falling/transition_request", "fall_right")
			anim_tree.set("parameters/Blend2/blend_amount", 1)
			anim_pos = anim_player.current_animation_position
			anim_tree.set("parameters/TimeSeek/seek_request", anim_pos)
		else:
			anim_tree.set("parameters/Blend2/blend_amount", 0)
			anim_pos = anim_player.current_animation_position
			anim_tree.set("parameters/TimeSeek/seek_request", anim_pos)
	elif !attacking and !reloading and !crouching:
		anim_tree.set("parameters/ground/transition_request", "idle")

func audio():
	if footstep_audio.playing and enable_player:
		if reloading:
			footstep_audio.pitch_scale = 1.25
		else:
			footstep_audio.pitch_scale = 2
	if !footstep_audio.playing and velocity.x != 0.0 and enable_player:
		footstep_audio.play()
	
	if Input.is_action_just_released("move_left") or Input.is_action_just_released("move_right") or !enable_player or velocity.x == 0.0:
		footstep_audio.stop()
		

func get_input():
	if Input.is_action_just_pressed("left_click") and !reloading and !shooting and !stabbing and !crouching: #and !is_jumping:
		shoot()
	if Input.is_action_just_pressed("right_click") and !reloading and !shooting and !stabbing and !crouching: #and !is_jumping:
		stab()
	if Input.is_action_just_pressed("crouch")and !attacking and !reloading and !stabbing and !crouching:
		crouch()
	if Input.is_action_just_released("crouch"):
		anim_tree.set("parameters/crouching/transition_request", "standup")

func crouch():
	# If already crouching, return.
	if crouching:
		return
	
	crouching = true
	anim_tree.set("parameters/crouching/transition_request", "crouch_idle")
	anim_tree.set("parameters/ground/transition_request", "crouch")

func shoot():
	primary_audio.stream = AudioManager.sounds["shoot"]
	primary_audio.play()
	attacking = true
	var bullet = preload("res://scenes/weapons/Bullet.tscn").instantiate()

	if facing == 0:
		anim_tree.set("parameters/attack/transition_request", "shoot_left")
		anim_tree.set("parameters/ground/transition_request", "attacking")
		bullet.direction = -1.0
	else:
		anim_tree.set("parameters/attack/transition_request", "shoot_right")
		anim_tree.set("parameters/ground/transition_request", "attacking")
		bullet.direction = 1.0
	
	bullet.global_position = gun_tip.global_position
	GameManager.level.call_deferred("add_child", bullet)

func stab():
	attacking = true
	anim_tree.set("parameters/ground/transition_request", "attacking")
	if facing == 0:
		anim_tree.set("parameters/attack/transition_request", "stab_left")
	else:
		anim_tree.set("parameters/attack/transition_request", "stab_right")

func reload():
	secondary_audio.stream = AudioManager.sounds["reload"]
	secondary_audio.play()
	reloading = true
	anim_player.play("reload")

func request_idle():
	stabbing = false
	shooting = false
	reloading = false
	attacking = false
	anim_tree.set("parameters/ground/transition_request", "idle")

func horizontal_movement():
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction and !shooting and !crouching:
		if reloading:
			velocity.x = lerpf(velocity.x, direction * reloading_movement_speed, acceleration)
		else:
			velocity.x = lerpf(velocity.x, direction * speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

func handle_jump(delta):
	if is_on_floor():
		anim_tree.set("parameters/in_air_state/transition_request", "ground")
#		is_jumping = false
#		can_jump = true
#		if jump_was_pressed:
#			jump()
	
	# Add the gravity.
	if not is_on_floor():
#		coyote_time()
		anim_tree.set("parameters/in_air_state/transition_request", "air")
		velocity.y += get_gravity() * delta
		velocity.y = clampf(velocity.y, -max_fall_velocity, max_fall_velocity)
		if velocity.y > 0:
			anim_tree.set("parameters/in_air/transition_request", "falling")
	
#	if Input.is_action_just_pressed("jump"):
#		jump_was_pressed = true
#		remember_jump_time()
#		if can_jump:
#			jump()

#	if Input.is_action_just_released("jump") and velocity.y < 0 and is_jumping:
#		velocity.y *= cut_height

func get_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

#func jump():
#	is_jumping = true
#	velocity.y = jump_velocity
#	anim_tree.set("parameters/in_air/transition_request", "jumping")
	
#func coyote_time():
#	await get_tree().create_timer(0.1).timeout
#	can_jump = false

#func remember_jump_time():
#	await get_tree().create_timer(0.1).timeout
#	jump_was_pressed = false

#func corner_correction():
#	if velocity.y < 0:
#		if cc_outer_left.get_collider() != null and cc_inner_left.get_collider() == null:
#			position.x += cc_push_amount
#
#		if cc_outer_right.get_collider() != null and cc_inner_right.get_collider() == null:
#			position.x -= cc_push_amount
#
func stair_check():
	if velocity.x != 0:
		if velocity.x < 0 and velocity.y == 0 and sc_ground_left.get_collider() != null and sc_head_left.get_collider() == null:
			position.x -= sc_push_amount
			position.y -= sc_push_amount
			#print("lef")
		if velocity.x > 0 and velocity.y == 0 and sc_ground_right.get_collider() != null and sc_head_right.get_collider() == null:
			position.x += sc_push_amount
			position.y -= sc_push_amount
#			#print("righ")
#
#func _on_item_pickup_range_body_entered(body):
#	if body.is_in_group("item"):
#		body.in_pickup_range(true)
#
#func _on_item_pickup_range_body_exited(body):
#	if body.is_in_group("item"):
#		body.in_pickup_range(false)

func _on_hitbox_body_entered(_body):
	pass

func _on_hitbox_body_exited(_body):
	pass

func _on_attack_box_body_entered(body):
	if body.is_in_group("enemy"):
		body.damage()

func damage():
	GameManager.health -= 1
	hurt_audio.play()
