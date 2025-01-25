extends Node

func _process(delta: float) -> void:
	$CanvasLayer/Label.text = str(GameState.kill_count)
