extends Node

@onready var maps = [
	$Map, $Map2
]

func _ready() -> void:
	#print($Map.size)
	pass

func _process(delta: float) -> void:
	%KillCount.text = str(GameState.kill_count)
	%SpawnedCount.text = str(GameState.enemy_spawns)

func _on_map_move_other_map(not_this_map: Variant, direction: Vector2) -> void:
	print(direction)
	var new_position = Vector2(not_this_map.size.x, 0) * direction + not_this_map.position
	for map in maps:
		if map != not_this_map:
			map.position = new_position
			break
	
