extends Node2D

var size = Vector2.ZERO
signal move_other_map(map, direction)


func _ready() -> void:
	size = $Floor.get_used_rect().size * $Floor.tile_set.tile_size


func _on_area_2d_body_entered(body: Node2D) -> void:
	var direction = Vector2.LEFT
	if body.global_position.x < $Area2D.global_position.x:
		direction = Vector2.RIGHT
	move_other_map.emit(self, direction)
