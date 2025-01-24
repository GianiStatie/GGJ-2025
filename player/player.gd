extends CharacterBody2D

@export var speed = 400
@export var aim_range=150
var dash_check=true
var speed_bufer=speed
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if !dash_check:
		speed_bufer=speed
	if Input.is_action_just_pressed("shift") and dash_check:
		dash_check=false
		$dash_timer.start(0)
		speed_bufer=speed*40
	velocity = input_direction * speed_bufer

#func _unhandled_input(event):
#	print (event)
	
func _physics_process(delta):
	get_input()
	#print(dash_check)
	move_and_slide()
	var mouse_pos_x=(self.global_position.x + aim_range * cos(self.get_angle_to(get_global_mouse_position())))
	var mouse_pos_y=(self.global_position.y + aim_range * sin(self.get_angle_to(get_global_mouse_position())))
	$aim.global_position=Vector2(mouse_pos_x , mouse_pos_y)
#x = cx + r * cos(a)
#y = cy + r * sin(a)


func _on_dash_timer_timeout() -> void:
	dash_check=true
	pass # Replace with function body.
