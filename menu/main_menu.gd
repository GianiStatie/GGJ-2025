extends Control

var scene = load("res://main.tscn")
#var scene = preload("res://my_scene.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	var instance = scene.instantiate()
	add_child(instance)
	pass # Replace with function body.
