extends CanvasLayer

var volume 

func _ready():
	get_tree().paused = true
	GameManager.music.attenuation = 6.0
	volume = $Panel/HBoxContainer/VBoxContainer/Volume/HBoxContainer/VolumeButton
	GameManager.change_music_volume.connect(_on_change_music_volume)
	_on_change_music_volume()

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		_on_resume_button_pressed()

func _on_resume_button_pressed():
	get_tree().paused = false
	GameManager.music.attenuation = 1.0
	queue_free()

func _on_exit_button_pressed():
	get_tree().paused = false
	GameManager.music.attenuation = 1.0
	GameManager.requested_scene = "res://scenes/menus/main_menu.tscn"
	get_tree().call_deferred("change_scene_to_packed", load("res://scenes/menus/loading_screen.tscn"))


func _on_volume_button_pressed():
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

func _on_change_music_volume():
	match GameManager.music_volume:
		-10.0:
			volume.texture_normal = load("res://assets/menu/pause/speaker_lvl_3.png")
		-20.0:
			volume.texture_normal = load("res://assets/menu/pause/speaker_lvl_2.png")
		-30.0:
			volume.texture_normal = load("res://assets/menu/pause/speaker_lvl_1.png")
		-200.0:
			volume.texture_normal = load("res://assets/menu/pause/speaker_mute.png")
	
	if GameManager.mute_music:
		GameManager.music.stop()
	elif !GameManager.mute_music and !GameManager.music.playing:
		GameManager.music.play()
