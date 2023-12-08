extends Node2D
#

# I was going to create a scene switcher to add to each scene. 
# That way I can have a UI seperate from the levels and an overall game scene.
# However, I did not have the time to implement this. If we continue working on 
# this project, I do plan to work on this. 

#func _ready():
	#GameManager.connect("switch_scene", switch_scene)
	#GameManager.scene_switcher = self
	#
#func switch_scene(scene_name : String):
	#var next_level
	#var next_level_name : String
	#
	## From scene switcher tutorial by jmbiv on Youtube. 
	#match(scene_name):
		#"start":
			#next_level_name = "Level01"
		#"fight":
			#next_level_name = "Level01"
			##next_level_name = "level02"
		#"final":
			#next_level_name = "Level03"
		#_:
			#return
	#
	#next_level = "res://scenes/levels/" +next_level_name +".tscn"
	#GameManager.requested_scene = next_level
	#
	#GameManager.level.queue_free()
	#
	#var loading_screen = preload("res://scenes/menus/loading_screen.tscn").instantiate()
	#add_child(loading_screen)
#
#
