extends Node2D

var size = Vector2.ZERO
signal move_other_map(map)


func _ready() -> void:
	size = $Floor.get_used_rect().size * $Floor.tile_set.tile_size


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	move_other_map.emit(self)


func _on_area_2d_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
