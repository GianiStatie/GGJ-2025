extends RigidBody2D

@onready var enemy_shape = $EnemyShape

var health: int = 100 : set = _on_health_changed


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		health -= 10

func _on_health_changed(value):
	enemy_shape.morph_to_circle(value / 100)
	health = max(value, 0)
