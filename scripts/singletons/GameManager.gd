extends Node2D

var level
var player
#var scene_switcher
var requested_scene : String
var music

var health := 3:
	set(value):
		health = value
		player_hurt.emit()
	get:
		return health

# Values can be -10, -20, -30, or mute. 
var music_volume : float = -10.0:
	set(value):
		music_volume = value
		change_music_volume.emit()
	get:
		return music_volume

var mute_music := false

var enemy_count := 0:
	set(value):
		enemy_count = value
		enemy_count_changed.emit()
	get:
		return enemy_count

signal switch_scene
signal change_music_volume
signal player_hurt
signal enemy_count_changed
