extends Node

var enemy_scene = preload("res://enemies/enemy.tscn")
var enemies: Array
var startTime = Time.get_ticks_msec()
var difficultyJumpSeconds = 20
var difficultySpikeSeconds = 60
var enemySpawnTimerSeconds = 60

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and GameState.can_nuke:
		for child in get_children():
			if child.is_in_group("enemy_group"):
				child.health -= 100
		GameState.can_nuke = false
		$NukeTimer.start()

func _process(delta: float) -> void:
	GameState.nuke_time = snapped($NukeTimer.time_left, 0.01) 

func _on_enemy_move_timer_timeout() -> void:
	var player = get_tree().get_nodes_in_group("player_group")[0]
	if player.is_dead:
		return
		
	var playerPosition = player.global_position
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy._follow_target(playerPosition)

# spawns enemies at random locations and makes them move towards the player
func _on_enemy_timer_timeout() -> void:
	
	var player = get_tree().get_nodes_in_group("player_group")[0]
	if player.is_dead:
		return
	
	var globalPlayerPosition = player.global_position	
	var globalEnemyPosition = _get_enemy_spawn_position()
	
	$RayCast2D.global_position = globalEnemyPosition
	$RayCast2D.target_position =  globalPlayerPosition - globalEnemyPosition
	$RayCast2D.force_raycast_update()
	#print($RayCast2D.get_collider())
	
	if $RayCast2D.get_collider() != player:
		_on_enemy_timer_timeout()
		return

	var enemy : Node2D = enemy_scene.instantiate()
	enemy._set_global_position(globalEnemyPosition)
	enemy._follow_target(globalPlayerPosition)
	_set_difficulty(enemy)
	
	add_child(enemy)
	enemies.append(enemy)
	GameState.enemy_spawns += 1
	
func _set_difficulty(enemy: Node2D) -> void:
	var currentTime = Time.get_ticks_msec()
	var elapsedSeconds = (currentTime - startTime) / 1000
	
	# every difficultyJumpSeconds increase difficulty by 10%
	var difficultyMultiplier = floor(elapsedSeconds / difficultyJumpSeconds) * 0.1 + 1
	# every difficultySpikeSeconds add 50% difficulty for difficultyJumpSeconds
	if elapsedSeconds >= difficultySpikeSeconds && elapsedSeconds % difficultySpikeSeconds < difficultyJumpSeconds:
		difficultyMultiplier = difficultyMultiplier * 1.5
	
	enemy.max_health = enemy.max_health * difficultyMultiplier
	enemy.damage = enemy.damage * difficultyMultiplier
	
	var enemySpawnPenalty = floor(elapsedSeconds / enemySpawnTimerSeconds) * 0.3
	var newSpawnTime = max($EnemyTimer.wait_time - enemySpawnPenalty, 0.6)
	$EnemyTimer.wait_time = newSpawnTime
		
func _get_enemy_spawn_position() -> Vector2:
	var screenRect = get_viewport().size
	var side = randi_range(0, 3)
	
	var xPosition = 0
	var yPosition = 0
	
	match side:
		0:
			xPosition = randf_range(0, screenRect.x)
			yPosition = 0
		1:
			xPosition = screenRect.x
			yPosition = randf_range(0, screenRect.y)
		2:
			xPosition = randf_range(0, screenRect.x)
			yPosition = screenRect.y
		3:
			xPosition = 0
			yPosition = randf_range(0, screenRect.y)
	
	var enemyPosition = Vector2(xPosition, yPosition)
	var globalEnemyPosition = (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse() * enemyPosition
	return globalEnemyPosition

func _on_nuke_timer_timeout() -> void:
	GameState.can_nuke = true
