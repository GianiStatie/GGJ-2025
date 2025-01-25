extends Control

var scene = load("res://menu/main_menu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().change_scene_to_packed(scene)
	#var instance = scene.instantiate()
	#add_child(instance)
	pass
