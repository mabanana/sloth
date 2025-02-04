extends Node2D
class_name Main

var input_handler: InputHandler = InputHandler.new()
var current_scene: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	current_scene = load("res://Combat/scene.tscn").instantiate()
	add_child(current_scene)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
