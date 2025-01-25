extends Node
var bullet1=preload("res://player/attacks/attack1.tscn").instantiate()
var random
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	random = RandomNumberGenerator.new()
	random.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func shoot(type,target,position):
	var tmp_attack
	if type ==1:
		tmp_attack=bullet1.duplicate()
		$attack_tracker.add_child(tmp_attack)
		tmp_attack.global_position=position
		tmp_attack.trigger(target+Vector2(randi_range(-30,30),randi_range(-30,30)))
