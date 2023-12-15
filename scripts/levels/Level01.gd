extends Node2D

var cutscene_player : AnimationPlayer 
var music : AudioStreamPlayer2D

# TODO:
# Fix error when crouching while reloading.

func _ready() -> void:
	GameManager.level = self
	cutscene_player = $CutscenePlayer as AnimationPlayer
	cutscene_player.play("intro_cutscene")
	music = $Music as AudioStreamPlayer2D
	GameManager.music = music
	GameManager.change_music_volume.connect(_on_change_music_volume)
	music.volume_db = GameManager.music_volume
	if !GameManager.mute_music:
		music.play()
		
	# Washington Animation:
	$NPCs/Washington/AnimationPlayer.play("go_go")

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

	if Input.is_action_just_pressed("pause"):
		var pause_menu = preload("res://scenes/menus/pause_menu.tscn").instantiate()
		GameManager.level.call_deferred("add_child", pause_menu)

func request_change_scene():
	GameManager.requested_scene = "res://scenes/levels/Level02.tscn"
	get_tree().call_deferred("change_scene_to_packed", load("res://scenes/menus/loading_screen.tscn"))

func _on_scene_switch_body_entered(body):
	if body.is_in_group("player"):
		cutscene_player.play("next_scene")
		#GameManager.emit_signal("switch_scene", "fight")

func _on_change_music_volume():
	#print(music.volume_db)
	music.volume_db = GameManager.music_volume

	if GameManager.mute_music:
		music.stop()
	elif !GameManager.mute_music and !music.playing:
		music.play()
	#print(music.volume_db)

# Audio changes should be -10db, -20, -30 and -200/mute (GameManager.muteMusic).


