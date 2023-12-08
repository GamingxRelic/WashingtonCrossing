extends Control

@onready var menu_music = $MenuMusic

func _ready():
	GameManager.level = self

func _on_play_button_pressed():
	GameManager.requested_scene = "res://scenes/levels/Level01.tscn"
	get_tree().change_scene_to_packed(load("res://scenes/menus/loading_screen.tscn"))
	#GameManager.switch_scene.emit("start")

func _on_menu_music_finished(): 
	menu_music.play() # To make the song loop.
