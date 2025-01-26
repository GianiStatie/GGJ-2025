extends Control

var scene = load("res://menu/main_menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/VBoxContainer/HBoxContainer/clean_count.text=str(GameState.kill_count)
	$VBoxContainer/VBoxContainer/HBoxContainer2/time_survived.text=format_time(GameState.session_time)
	pass # Replace with function body.

func format_time(total_seconds: int) -> String:
	var minutes = total_seconds / 60.0
	var seconds = total_seconds % 60# We want to display two digits for milliseconds
	return "%02d:%02d"%[minutes, seconds]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#var instance = scene.instantiate()
	#add_child(instance)
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(scene)
	pass # Replace with function body.
