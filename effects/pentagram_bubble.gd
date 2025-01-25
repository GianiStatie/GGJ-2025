extends Node2D


func _on_enemy_player_health_perc_changed(perc: Variant) -> void:
	$Shape.morph_to_circle(1 - perc)
