extends Node

@onready var maps = [
	$Map, $Map2
]
var damage_flash_on = false
var damage_flash_alpha = 0
func _ready() -> void:
	#print($Map.size)
	pass

func _process(delta: float) -> void:
	%KillCount.text = str(GameState.kill_count)
	if GameState.can_nuke:
		%NukeTimer.text = "PRESS SPACE TO NUKE"
	else:
		%NukeTimer.text = "%s seconds"%[GameState.nuke_time]
	$CanvasLayer/VBoxContainer/HBoxContainer3/dash_indicator.value=GameState.pc_dash_time
	if GameState.pc_dash_time == 0:
		$CanvasLayer/VBoxContainer/HBoxContainer3/dash_text_indicator.visible=true
	else:
		$CanvasLayer/VBoxContainer/HBoxContainer3/dash_text_indicator.visible=false
	$"CanvasLayer/VBoxContainer/hp track/hp".value=GameState.pc_hp
	
	if damage_flash_on:
		damage_flash_alpha += 10
		if damage_flash_alpha >= 120:
			damage_flash_on = false
		else:
			var damageFlash = get_node("CanvasLayer/DamageFlash")
			damageFlash.color.a8 = damage_flash_alpha
	elif damage_flash_alpha > 0:
		damage_flash_alpha -= 2
		var damageFlash = get_node("CanvasLayer/DamageFlash")
		damageFlash.color.a8 = damage_flash_alpha

func _on_map_move_other_map(not_this_map: Variant, direction: Vector2) -> void:
	var position_shift = Vector2(not_this_map.size.x, 0) * direction
	for map in maps:
		if map != not_this_map:
			map.position = not_this_map.position + position_shift
			break

func _trigger_damage_flash() -> void:
	damage_flash_on = true
	
