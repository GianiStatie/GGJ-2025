extends Node

var enemy_scene = preload("res://enemies/enemy.tscn").instantiate()
var enemies: Array

func _on_enemy_move_timer_timeout() -> void:
	var playerPosition = get_tree().get_nodes_in_group("player_group")[0].global_position
	for enemy in enemies:
		if is_instance_valid(enemy):
			enemy._follow_target(playerPosition)

# spawns enemies at random locations and makes them move towards the player
func _on_enemy_timer_timeout() -> void:
	var globalEnemyPosition = _get_enemy_spawn_position()
	var globalPlayerPosition = get_tree().get_nodes_in_group("player_group")[0].global_position
	
	var enemy : Node2D = enemy_scene.duplicate()
	enemy._set_global_position(globalEnemyPosition)
	enemy._follow_target(globalPlayerPosition)
	
	add_child(enemy)
	enemies.append(enemy)

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
