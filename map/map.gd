extends Node2D

var size = Vector2.ZERO
signal move_other_map(map, direction)


func _ready() -> void:
	size = $Floor.get_used_rect().size * $Floor.tile_set.tile_size


func _on_left_area_body_entered(body: Node2D) -> void:
	var direction = Vector2.LEFT
	move_other_map.emit(self, direction)


func _on_right_area_body_entered(body: Node2D) -> void:
	var direction = Vector2.RIGHT
	move_other_map.emit(self, direction)
