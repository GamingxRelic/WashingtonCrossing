extends CanvasLayer

@onready var health_label = $VBoxContainer/Health
@onready var enemies_rem_label = $VBoxContainer2/EnemiesRem

func _ready():
	GameManager.enemy_count_changed.connect(_on_enemy_count_changed)
	enemies_rem_label.text = "Enemies spawning!"

func _process(_delta):
	#fps_label.text = str(Performance.get_monitor(Performance.TIME_FPS)) + " FPS"
	health_label.text = "Health: " +str(GameManager.health) +" / 3"

func _on_enemy_count_changed():
	if GameManager.enemy_count == 0:
		enemies_rem_label.text = "All enemies defeated!"
	else:
		enemies_rem_label.text = "Enemies Remaining: " +str(GameManager.enemy_count)
