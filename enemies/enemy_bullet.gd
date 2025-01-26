extends RigidBody2D

var damage = 20
var health: float = 1 : set = _on_health_changed
var triggered = true

func _on_health_changed(value):
	if health <= 0:
		queue_free()

func _on_screen_check_screen_exited() -> void:
	self.visible=false
	queue_free()
	pass # Replace with function body.

func _on_colistion_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		self.visible=false
	if body.is_in_group("player_group"):
		body.health -= damage
	queue_free()
	
func _set_global_position(position: Vector2) -> void:
	global_position = position
	
func _follow_target(target: Vector2) -> void:
	if triggered:
		self.look_at(target)
		self.apply_impulse(Vector2(target-self.global_position).normalized()*250)
		triggered = false
