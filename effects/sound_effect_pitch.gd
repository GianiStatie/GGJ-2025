extends AudioStreamPlayer2D

var rng = RandomNumberGenerator.new()


func _ready() -> void:
	var pitch_variation = rng.randf_range(-0.2, 0.4)
	pitch_scale += pitch_variation
