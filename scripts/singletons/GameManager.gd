extends Node2D

var level
var player
#var scene_switcher
var requested_scene : String

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

signal switch_scene
signal change_music_volume
signal player_hurt
