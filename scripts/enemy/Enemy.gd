extends CharacterBody2D

var speed := 50.0

var direction = 1:
	set(value):
		direction = value
		if value == -1:
			$Sprite2D.flip_h = true
			$Attacking/GunTip.position = Vector2(-21,-8)
		else:
			$Sprite2D.flip_h = false
			$Attacking/GunTip.position = Vector2(21,-8)
	get:
		return direction
		
var player_detected := false
var in_shoot_range := false
var in_stab_range := false
var shooting := false
var stabbing := false
var walking := false

@onready var shoot_cooldown := $Timers/Shoot_Cooldown
@onready var stab_cooldown := $Timers/Stab_Cooldown

@onready var anim := $AnimationPlayer as AnimationPlayer

@onready var gun_tip := $Attacking/GunTip

@onready var primary_audio := $Audio/PrimaryAudio
@onready var secondary_audio := $Audio/SecondaryAudio
@onready var footstep_audio := $Audio/Footsteps

func _physics_process(_delta):
	
	if player_detected and !shooting and !stabbing:
		if direction == -1:
			velocity.x = -speed
		else:
			velocity.x = speed
		walking = true
	else:
		velocity.x = 0.0
		walking = false
	
	velocity.y = 10
	
	if in_shoot_range and !GameManager.player.crouching and !shooting and !stabbing:
		shoot()
	elif in_stab_range and !shooting and !stabbing:
		stab()
	
	animations()
	audio()
	
	move_and_slide()

func animations():
	if walking and !shooting and !stabbing:
		anim.play("run")
	elif !walking and !shooting and !stabbing: # and velocity.x == 0:
		anim.play("idle")
	
func audio():
	if walking:
		if !footstep_audio.playing:
			footstep_audio.play()
	else:
		footstep_audio.stop()
	
func damage():
	queue_free()

func shoot():
	shooting = true
	anim.play("shoot")
	
	primary_audio.stream = AudioManager.sounds["shoot"]
	primary_audio.play()
	
	var bullet = preload("res://scenes/enemy/enemy_bullet.tscn").instantiate()
	bullet.direction = direction
	bullet.global_position = gun_tip.global_position
	bullet.target = "player"
	GameManager.level.call_deferred("add_child", bullet)

func stab():
	stabbing = true
	anim.play("stab")
	
	
func _on_animation_player_animation_finished(anim_name):
	match(anim_name):
		"shoot":
			shoot_cooldown.start()
		"stab":
			stab_cooldown.start()

func _on_left_detection_area_body_entered(body):
	if body.is_in_group("player"):
		direction = -1
		player_detected = true


func _on_right_detection_area_body_entered(body):
	if body.is_in_group("player"):
		direction = 1
		player_detected = true


func _on_left_shoot_detection_body_entered(body):
	if body.is_in_group("player"):
		direction = -1
		in_shoot_range = true

func _on_left_shoot_detection_body_exited(body):
	if body.is_in_group("player"):
		in_shoot_range = false

func _on_right_shoot_detection_body_entered(body):
	if body.is_in_group("player"):
		direction = 1
		in_shoot_range = true

func _on_right_shoot_detection_body_exited(body):
	if body.is_in_group("player"):
		in_shoot_range = false

func _on_left_stab_detection_body_entered(body):
	if body.is_in_group("player"):
		direction = -1
		in_stab_range = true

func _on_left_stab_detection_body_exited(body):
	if body.is_in_group("player"):
		in_stab_range = false

func _on_shoot_cooldown_timeout():
	shooting = false

func _on_stab_cooldown_timeout():
	stabbing = false

func _on_attack_box_body_entered(body):
	if body.is_in_group("player"):
		body.damage()
