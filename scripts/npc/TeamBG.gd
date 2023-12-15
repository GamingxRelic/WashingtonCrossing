extends Sprite2D

var anim : AnimationPlayer

func _ready():
	anim = $AnimationPlayer
	var rand_start = randf_range(0.0, 1.0)
	var timer = get_tree().create_timer(rand_start)
	timer.timeout.connect(play_anim)

func play_anim():
	anim.play("background_npc_anim")
