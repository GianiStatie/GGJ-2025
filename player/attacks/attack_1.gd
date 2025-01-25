extends RigidBody2D

var damage = 34

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func trigger(target):
	self.look_at(target)
	self.apply_impulse(Vector2(target-self.global_position).normalized()*200)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_screen_check_screen_exited() -> void:
	self.visible=false
	queue_free()
	pass # Replace with function body.



func _on_colistion_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		self.visible=false
	if body.is_in_group("enemy_group"):
		body.health -= damage
	queue_free()
