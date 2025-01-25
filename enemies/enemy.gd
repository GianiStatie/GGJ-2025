extends RigidBody2D

@onready var enemy_shape = $EnemyShape
@export var speed = 200

var max_health: float = 100
var health: float = max_health : set = _on_health_changed

signal player_health_perc_changed(perc)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		health -= 10

func _on_health_changed(value):
	var new_health = max(value, 0)
	if new_health != health:
		var progression = value / max_health
		player_health_perc_changed.emit(progression)
		health = new_health

func _set_global_position(position: Vector2) -> void:
	global_position = position
	
func _follow_target(target_position: Vector2) -> void:
	var direction = global_position.direction_to(target_position)
	look_at(direction)
	linear_velocity = speed * direction
