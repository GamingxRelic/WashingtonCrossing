extends CanvasLayer

@onready var fps_label = $VBoxContainer/FPS

func _process(_delta):
	#fps_label.text = str(Performance.get_monitor(Performance.TIME_FPS)) + " FPS"
	fps_label.text = "Health: " +str(GameManager.health) +" / 3"
