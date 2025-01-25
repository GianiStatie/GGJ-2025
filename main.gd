extends Node

@onready var maps = [
	$Map, $Map2
]

func _ready() -> void:
	#print($Map.size)
	pass

func _process(delta: float) -> void:
	%KillCount.text = str(GameState.kill_count)
	if GameState.can_nuke:
		%NukeTimer.text = "PRESS SPACE TO NUKE"
	else:
		%NukeTimer.text = "%s seconds"%[GameState.nuke_time]

func _on_map_move_other_map(not_this_map: Variant, direction: Vector2) -> void:
	var position_shift = Vector2(not_this_map.size.x, 0) * direction
	for map in maps:
		if map != not_this_map:
			map.position = not_this_map.position + position_shift
			break
	
