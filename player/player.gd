extends CharacterBody2D

@export var speed = 180


@export var aim_range=50
var dash_check=true
var speed_bufer=speed
func get_input():
	#var input_direction = Input.get_vector("left", "right", "up", "down")
	var input_direction = Input.get_vector("a", "d", "w", "s")
	if !dash_check:
		speed_bufer=speed
	if Input.is_action_just_pressed("shift") and dash_check:
		dash_check=false
		$dash_timer.start(0)
		speed_bufer=speed*40
	velocity = input_direction * speed_bufer
	if Input.is_action_just_pressed("mouse_l_click") and self.global_position.distance_to(get_global_mouse_position()) >aim_range:
		get_tree().get_nodes_in_group("pc_attack_tracker")[0].shoot(1,get_global_mouse_position(),$aim.global_position)

#func _unhandled_input(event):
#	print (event)
	
func _physics_process(delta):
	get_input()
	#print(dash_check)
	move_and_slide()
	var mouse_pos_x=(self.global_position.x + aim_range * cos(self.get_angle_to(get_global_mouse_position())))
	var mouse_pos_y=(self.global_position.y + aim_range * sin(self.get_angle_to(get_global_mouse_position())))
	$aim.global_position=Vector2(mouse_pos_x , mouse_pos_y)



func _on_dash_timer_timeout() -> void:
	dash_check=true
	pass # Replace with function body.
