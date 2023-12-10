extends CharacterBody2D

var direction := 1.0
@export var speed := 50000.0
var target := "enemy"

func _physics_process(delta) -> void:
	velocity.x = speed*direction*delta
	move_and_slide()

func _on_timer_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group(target):
		body.damage()
		queue_free()
	else:
		queue_free()
