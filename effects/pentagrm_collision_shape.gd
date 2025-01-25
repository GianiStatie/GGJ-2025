extends CollisionPolygon2D


func _on_shape_shape_changed(shape: Variant) -> void:
	polygon = shape
