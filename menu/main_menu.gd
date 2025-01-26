extends Control


#var scene = preload("res://my_scene.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	var scene = load("res://main.tscn")
	get_tree().change_scene_to_packed(scene)
	#var instance = scene.instantiate()
	#add_child(instance)
	pass # Replace with function body.


func _on_info_pressed() -> void:
	var scene = load("res://menu/INFO.tscn")
	get_tree().change_scene_to_packed(scene)
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	var scene = load("res://menu/how_to.tscn")
	get_tree().change_scene_to_packed(scene)
	pass # Replace with function body.
