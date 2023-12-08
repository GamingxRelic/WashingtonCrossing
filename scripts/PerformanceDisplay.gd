extends CanvasLayer

@onready var fps_label = $VBoxContainer/FPS

func _process(_delta):
	fps_label.text = str(Performance.get_monitor(Performance.TIME_FPS)) + " FPS"
