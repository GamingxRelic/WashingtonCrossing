extends Control

@onready var menu_music = $MenuMusic

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(load("res://scenes/menus/loading_screen.tscn"))
	GameManager.requested_scene = "res://scenes/levels/TestLevel.tscn"

func _on_menu_music_finished():
	menu_music.play()
