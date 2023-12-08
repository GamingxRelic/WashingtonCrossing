extends Node2D

var cutscene_player : AnimationPlayer 

func _ready() -> void:
	GameManager.level = self
	cutscene_player = $CutscenePlayer as AnimationPlayer
	cutscene_player.play("intro_cutscene")

# TODO:
# Add enemy
# Add action level with enemies
# Add tutorial parts on the first level
# Add scene switcher


func _on_scene_switch_body_entered(body):
	if body.is_in_group("player"):
		GameManager.requested_scene = "res://scenes/levels/Level02.tscn"
		get_tree().call_deferred("change_scene_to_packed", load("res://scenes/menus/loading_screen.tscn"))
		#GameManager.emit_signal("switch_scene", "fight")
