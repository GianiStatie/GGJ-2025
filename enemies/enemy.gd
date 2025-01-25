extends RigidBody2D

@export var speed = 50
@onready var animation_player = $AnimationPlayer

var max_health: float = 100
var health: float = max_health : set = _on_health_changed
var damage: float = 10
var isPlayerCollision = false
var effect = preload("res://effects/bubble_dead_particles.tscn")
var bounceCount = 1

signal player_health_perc_changed(perc)


func _on_health_changed(value):
	var new_health = max(value, 0)
	if new_health < health:
		$PentagramBubble.visible = true
	if new_health != health:
		var progression = value / max_health
		player_health_perc_changed.emit(progression)
		health = new_health
		animation_player.play("Damaged")
	if health <= 0:
		queue_free()

func _set_global_position(position: Vector2) -> void:
	global_position = position
	
func _follow_target(target_position: Vector2) -> void:
	if isPlayerCollision:
		return
		
	var direction = global_position.direction_to(target_position).normalized()
	linear_velocity = speed * direction
	$Sprite2D.flip_h = direction.x < 0

func _on_player_collision() -> void:
	isPlayerCollision  = true
	var currentDirection = linear_velocity / speed
	var bounceDirection = currentDirection * -1
	look_at(bounceDirection)
	linear_velocity = bounceDirection * speed * 5
	var timer = get_node("BounceTimer")
	timer.start()

func _on_bounce_timer_timeout() -> void:
	bounceCount+=1
	linear_velocity = linear_velocity / bounceCount
	
	if bounceCount == 10:
		isPlayerCollision = false
		var timer = get_node("BounceTimer")
		timer.stop()
	
func _on_tree_exiting() -> void:
	GameState.kill_count += 1
	Utils.instance_scene_on_main(effect, global_position)
