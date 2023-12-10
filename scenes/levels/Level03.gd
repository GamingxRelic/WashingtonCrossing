extends Node2D

var music : AudioStreamPlayer2D

func _ready() -> void:
	GameManager.level = self
	music = $Music as AudioStreamPlayer2D
	GameManager.change_music_volume.connect(_on_change_music_volume)
	music.volume_db = GameManager.music_volume
	if !GameManager.mute_music:
		music.play()
		
	# campfire
	$Campfire/AnimationPlayer.play("fire")
	$NPC/Washington/AnimationPlayer.play("idle")

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
				
func _on_change_music_volume():
	print(music.volume_db)
	music.volume_db = GameManager.music_volume
	
	if GameManager.mute_music:
		music.stop()
	elif !GameManager.mute_music and !music.playing:
		music.play()
	print(music.volume_db)
	
