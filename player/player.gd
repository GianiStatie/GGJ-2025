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

@export var camera: Camera2D

func _ready():
	GameState.pc_hp=max_health
	$RemoteTransform2D.remote_path = camera.get_path()

func _on_health_changed(value):
	health = max(value, 0)
	GameState.pc_hp=health
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
		$blur.visible=true
		$dash_timer.start()
		$blur.look_at(input_direction*10000)
		$blursoundefect.play()
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

var level_rewards = [[5, false], [8, false], [15, false], [25, false], [40, false], [55, false], [70, false], [85, false], [100, false], [120, false], [150, false], [200, false], ]

func _process(delta: float) -> void:
	print($dash_timer.time_left)
	if $dash_timer.time_left <4.5:
		$blur.visible=false
	var kill_tracker=GameState.kill_count
	GameState.pc_dash_time = snapped($dash_timer.time_left, 0.01) 
	if kill_tracker > level_rewards[0][0] && !level_rewards[0][1]:
			speed+=15
			level_rewards[0][1] = true
	if kill_tracker > level_rewards[1][0] && !level_rewards[1][1]:
			damage_modifier+=25
			bullet_count+=1
			level_rewards[1][1] = true
	if kill_tracker > level_rewards[2][0] && !level_rewards[2][1]:
			speed+=10
			level_rewards[2][1] = true
	if kill_tracker > level_rewards[3][0] && !level_rewards[3][1]:
			attack_spee-=0.3
			level_rewards[3][1] = true
	if kill_tracker > level_rewards[4][0] && !level_rewards[4][1]:
			speed+=5
			level_rewards[4][1] = true
	if kill_tracker > level_rewards[5][0] && !level_rewards[5][1]:
			attack_spee-=0.2
			level_rewards[5][1] = true
	if kill_tracker > level_rewards[6][0] && !level_rewards[6][1]:
			damage_modifier+=17
			level_rewards[6][1] = true
	if kill_tracker > level_rewards[7][0] && !level_rewards[7][1]:
			damage_modifier+=15
			level_rewards[7][1] = true
	if kill_tracker > level_rewards[8][0] && !level_rewards[8][1]:
			speed+=20
			level_rewards[8][1] = true
	if kill_tracker > level_rewards[9][0] && !level_rewards[9][1]:
			attack_spee-=0.2
			level_rewards[9][1] = true
	if kill_tracker > level_rewards[10][0] && !level_rewards[10][1]:
			speed+=10
			level_rewards[10][1] = true
	if kill_tracker > level_rewards[11][0] && !level_rewards[11][1]:
			damage_modifier+=20
			bullet_count+=1
			level_rewards[11][1] = true
	pass

func _on_attack_timer_timeout() -> void:
	can_shot=true
	pass # Replace with function body.
