extends RigidBody2D

@export var speed = 50

var max_health: float = 30
var health: float = max_health : set = _on_health_changed
var damage: float = 10
var isPlayerCollision = false
var effect = preload("res://effects/bubble_dead_particles.tscn")

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
	if health <= 0:
		queue_free()

func _set_global_position(position: Vector2) -> void:
	global_position = position
	
func _follow_target(target_position: Vector2) -> void:
	if isPlayerCollision:
		return
		
	var direction = global_position.direction_to(target_position)
	look_at(direction)
	linear_velocity = speed * direction

func _on_player_collision() -> void:
	isPlayerCollision  = true
	var currentDirection = linear_velocity / speed
	var bounceDirection = currentDirection * -1
	look_at(bounceDirection)
	linear_velocity = bounceDirection * speed * 2
	var timer = get_node("BounceTimer")
	timer.start()

func _on_bounce_timer_timeout() -> void:
	isPlayerCollision = false
	
func _on_tree_exiting() -> void:
	Utils.instance_scene_on_main(effect, global_position)
