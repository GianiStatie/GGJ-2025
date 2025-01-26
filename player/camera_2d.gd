extends Camera2D

var random_strength: float = 30.0
var shake_fade: float = 5.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0


func apply_shake():
	shake_strength = random_strength

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = random_offset()

func random_offset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _on_spawner_nuking_time() -> void:
	apply_shake()
