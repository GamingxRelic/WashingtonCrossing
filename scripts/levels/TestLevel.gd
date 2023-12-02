extends Node2D

var cutscene_player : AnimationPlayer 

func _ready() -> void:
	GameManager.level = self
	cutscene_player = $CutscenePlayer as AnimationPlayer
	cutscene_player.play("intro_cutscene")
