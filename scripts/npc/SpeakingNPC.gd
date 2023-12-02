extends Area2D

@export var dialog_options = []

var in_range := false
var dialog_label : Label 

func _ready() -> void:
	dialog_label = $Dialog
	new_dialog()

func _process(_delta) -> void:
	if in_range and Input.is_action_just_pressed("interact"):
		new_dialog()

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		in_range = true

func _on_body_exited(body) -> void:
	if body.is_in_group("player"):
		in_range = false

func new_dialog() -> void:
	var rand_int = randi_range(0,dialog_options.size()-1)
	dialog_label.text = dialog_options[rand_int]
	print(dialog_label.text)
