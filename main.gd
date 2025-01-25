extends Node


func _ready() -> void:
	print($Map.size)

func _process(delta: float) -> void:
	%KillCount.text = str(GameState.kill_count)
	%SpawnedCount.text = str(GameState.enemy_spawns)

func _on_map_move_other_map(map: Variant) -> void:
	print('iz colide')
	print(map.position)
