extends Control

var scene = load("res://menu/main_menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/HBoxContainer/clean_count.text=str(GameState.kill_count)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#var instance = scene.instantiate()
	#add_child(instance)
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(scene)
	pass # Replace with function body.
