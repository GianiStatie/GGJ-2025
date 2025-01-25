extends CharacterBody2D

var scene = load("res://menu/end.tscn")


var speed = 70
var aim_range=15
var max_health: float = 100
var health: float = max_health : set = _on_health_changed
var dash_check=true
var speed_bufer=speed
var is_dead = false
var can_shot=true
var damage_modifier=0
var attack_spee=0.8
var bullet_count=1
func _on_health_changed(value):
	health = max(value, 0)
	if health <= 0:
		is_dead = true
		get_tree().change_scene_to_packed(scene)

func get_input():
	if is_dead:
		return
	#var input_direction = Input.get_vector("left", "right", "up", "down")
	var input_direction = Input.get_vector("a", "d", "w", "s")
	if !dash_check:
		speed_bufer=speed
	if Input.is_action_just_pressed("shift") and dash_check:
		dash_check=false
		$dash_timer.start(attack_spee)
		speed_bufer=speed*40
	velocity = input_direction * speed_bufer 
	if Input.is_action_just_pressed("mouse_l_click") and can_shot and self.global_position.distance_to(get_global_mouse_position()) >aim_range:
		can_shot=false
		var start_pos = $aim/AimMarker.global_position
		
		for i in range(0,bullet_count):
			get_tree().get_nodes_in_group("pc_attack_tracker")[0].shoot(1,get_global_mouse_position(),start_pos,damage_modifier)
		$attack_timer.start(attack_spee)
#func _unhandled_input(event):
#	print (event)
	
func _physics_process(delta):
	if is_dead:
		return
	get_input()
	
	#print(dash_check)
	move_and_slide()
	var mouse_pos_x=(self.global_position.x + aim_range * cos(self.get_angle_to(get_global_mouse_position())))
	var mouse_pos_y=(self.global_position.y + aim_range * sin(self.get_angle_to(get_global_mouse_position())))
	$aim.global_position=Vector2(mouse_pos_x , mouse_pos_y)
	
	var mouse_direction = global_position.direction_to($aim.global_position)
	$CharacterSprite.flip_h = mouse_direction.x < 0
	
	if velocity == Vector2.ZERO:
		$CharacterSprite.play("Idle")
	else:
		$CharacterSprite.play("Run")
		

func _on_dash_timer_timeout() -> void:
	dash_check=true
	pass # Replace with function body.
	
func _on_collision_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy_group"):
		health -= body.damage
		body._on_player_collision()


func _process(delta: float) -> void:
	var kill_tracker=GameState.kill_count
	match kill_tracker:
		10:
			speed+=15
			GameState.kill_count+=1
		15:
			damage_modifier+=25
			bullet_count+=1
			GameState.kill_count+=1
		20:
			speed+=10
			GameState.kill_count+=1
		25:
			attack_spee-=0.3
			GameState.kill_count+=1
		30:
			speed+=5
			GameState.kill_count+=1
		35:
			attack_spee-=0.2
			GameState.kill_count+=1
		40:
			damage_modifier+=17
			GameState.kill_count+=1
		45:
			damage_modifier+=15
			GameState.kill_count+=1
		50:
			speed+=20
			GameState.kill_count+=1
		55:
			attack_spee-=0.2
			GameState.kill_count+=1
		70:
			speed+=10
			GameState.kill_count+=1
		80:
			damage_modifier+=20
			bullet_count+=1
			GameState.kill_count+=1
	pass

func _on_attack_timer_timeout() -> void:
	can_shot=true
	pass # Replace with function body.
