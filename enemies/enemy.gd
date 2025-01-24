extends RigidBody2D

@onready var enemy_shape = $EnemyShape
@export var speed = 200

var health: float = 100 : set = _on_health_changed


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		health -= 5

func _on_health_changed(value):
	var progression = 1 - (value / 100)
	enemy_shape.morph_to_circle(progression)
	health = max(value, 0)

func _set_global_position(position: Vector2) -> void:
	global_position = position
	
func _follow_target(target_position: Vector2) -> void:
	var direction = global_position.direction_to(target_position)
	look_at(direction)
	linear_velocity = speed * direction
