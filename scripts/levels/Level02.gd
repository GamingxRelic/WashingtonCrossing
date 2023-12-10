extends Node2D

var cutscene_player : AnimationPlayer 
var music : AudioStreamPlayer2D

func _ready() -> void:
	GameManager.level = self
	cutscene_player = $CutscenePlayer as AnimationPlayer
	cutscene_player.play("intro_cutscene")
	music = $Music as AudioStreamPlayer2D
	GameManager.change_music_volume.connect(_on_change_music_volume)
	music.volume_db = GameManager.music_volume
	if !GameManager.mute_music:
		music.play()
		
	GameManager.health = 3
	GameManager.player_hurt.connect(_on_player_hurt)

func _on_player_hurt():
	if GameManager.health <= 0:
		cutscene_player.play("next_scene")

func _process(_delta):
	if Input.is_action_just_pressed("volume"):
		match GameManager.music_volume:
			-10.0:
				GameManager.music_volume = -20.0
			-20.0:
				GameManager.music_volume = -30.0
			-30.0:
				GameManager.music_volume = -200.0
				GameManager.mute_music = true
			-200.0:
				GameManager.music_volume = -10.0
				GameManager.mute_music = false
				music.play()

func request_change_scene():
	if GameManager.health > 0:
		GameManager.requested_scene = "res://scenes/levels/Level03.tscn"
	else:
		GameManager.requested_scene = "res://scenes/levels/Level02.tscn"
	get_tree().call_deferred("change_scene_to_packed", load("res://scenes/menus/loading_screen.tscn"))

func _on_scene_switch_body_entered(body):
	if body.is_in_group("player"):
		cutscene_player.play("next_scene")
		#GameManager.emit_signal("switch_scene", "fight")

func _on_change_music_volume():
	print(music.volume_db)
	music.volume_db = GameManager.music_volume
	
	if GameManager.mute_music:
		music.stop()
	elif !GameManager.mute_music and !music.playing:
		music.play()
	print(music.volume_db)

# Audio changes should be -10db, -20, -30, and -200/mute (GameManager.muteMusic).
func _on_music_finished():
	pass
	#if !GameManager.mute_music:
		#music.play()
