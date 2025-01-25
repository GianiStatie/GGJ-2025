extends CharacterBody2D

var scene = load("res://menu/end.tscn")

var speed = 8000
var aim_range=18
var max_health: float = 100
var health: float = max_health : set = _on_health_changed
var dash_check=true
var speed_bufer=speed
var is_dead = false

func _on_health_changed(value):
	health = max(value, 0)
	if health <= 0:
		is_dead = true
		get_tree().change_scene_to_packed(scene)

func get_input(delta):
	if is_dead:
		return
	#var input_direction = Input.get_vector("left", "right", "up", "down")
	var input_direction = Input.get_vector("a", "d", "w", "s")
	if !dash_check:
		speed_bufer=speed
	if Input.is_action_just_pressed("shift") and dash_check:
		dash_check=false
		$dash_timer.start(0)
		speed_bufer=speed*40
	velocity = input_direction * speed_bufer *delta
	if Input.is_action_just_pressed("mouse_l_click") and self.global_position.distance_to(get_global_mouse_position()) >aim_range:
		var start_pos = $aim/AimMarker.global_position
		get_tree().get_nodes_in_group("pc_attack_tracker")[0].shoot(1,get_global_mouse_position(),start_pos)

#func _unhandled_input(event):
#	print (event)
	
func _physics_process(delta):
	if is_dead:
		return
	get_input(delta)
	
	#print(dash_check)
	move_and_slide()
	var mouse_pos_x=(self.global_position.x + aim_range * cos(self.get_angle_to(get_global_mouse_position())))
	var mouse_pos_y=(self.global_position.y + aim_range * sin(self.get_angle_to(get_global_mouse_position())))
	$aim.global_position=Vector2(mouse_pos_x , mouse_pos_y)


func _on_dash_timer_timeout() -> void:
	dash_check=true
	pass # Replace with function body.
	
func _on_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy_group"):
		health -= body.damage
		body._on_player_collision()
