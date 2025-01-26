extends RigidBody2D

@export var speed = 50
@onready var animation_player = $AnimationPlayer
var default_sprite = "level1"

var max_health: float = 100 : set = _on_max_health_changed
var health: float = max_health : set = _on_health_changed
var damage: float = 10
var isPlayerCollision = false
var effect = preload("res://effects/bubble_dead_particles.tscn")
var bounceCount = 1
var last_position=Vector2(0,0)
var anti_stuck_counter=10

signal player_health_perc_changed(perc)

func _on_max_health_changed(value):
	max_health = value
	health = value
	# I know it can be done better, but not today
	if max_health >= 110.0:
		default_sprite = "level2"
	if max_health >= 120.0:
		default_sprite = "level3"
	if max_health >= 130.0:
		default_sprite = "level4"
	if max_health >= 140.0:
		default_sprite = "level5"
	if max_health >= 150.0:
		default_sprite = "level6"

func _ready() -> void:
	last_position=self.global_position
	$Sprite2D.play(default_sprite)

func _on_health_changed(value):
	var new_health = max(value, 0)
	if new_health < health:
		$PentagramBubble.visible = true
	if new_health != health:
		var progression = value / max_health
		if progression < 1:
			player_health_perc_changed.emit(progression)
			animation_player.play("Damaged")
			$AudioStreamPlayer2D.play()
		health = new_health
	if health <= 0:
		queue_free()

func _set_global_position(position: Vector2) -> void:
	global_position = position
	
func _follow_target(target_position: Vector2) -> void:
	if isPlayerCollision:
		return
	if self.global_position.distance_to(last_position) <2 and anti_stuck_counter>0:
		
		anti_stuck_counter-=1
		if anti_stuck_counter < 6:
			$CollisionShape2D.disabled=true
	else:
		anti_stuck_counter+=1
	last_position=self.global_position
	if anti_stuck_counter == 0 or anti_stuck_counter ==10:
		anti_stuck_counter=10
		$CollisionShape2D.disabled=false
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
