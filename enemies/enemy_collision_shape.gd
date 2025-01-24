extends CollisionPolygon2D


func _on_enemy_shape_shape_changed(shape: Variant) -> void:
	polygon = shape
