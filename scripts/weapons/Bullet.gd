extends CharacterBody2D

var direction := 1.0
var speed := 50000.0

func _physics_process(delta) -> void:
	velocity.x = speed*direction*delta
	move_and_slide()

func _on_timer_timeout():
	queue_free()
