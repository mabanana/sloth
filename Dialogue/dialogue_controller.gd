extends Control
class_name DialogueController

var main: Main

var dialogue_tree: Dictionary
var current_node: Dictionary
var json_parser: JsonParser
var input_handler: InputHandler
var json_path: String

@export var text_label: Label
@export var speaker_label: Label
@export var end_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	json_parser = main.json_parser
	input_handler = main.input_handler

func _input(event):
	var result: Dictionary = input_handler.handle_input(event)
	if result:
		if result.context == InputHandler.Context.key_pressed or result.context == InputHandler.Context.mouse_pressed:
			next_node()

func start(json_path):
	show()
	dialogue_tree = json_parser.load_json(json_path)
	if dialogue_tree and dialogue_tree["nodes"]["start"]:
		current_node = dialogue_tree["nodes"]["start"]
	_update()

func _update():
	text_label.text = current_node["text"]
	speaker_label.text = current_node["speaker"]
	end_label.visible = !len(current_node.choices)

func next_node(index = 0):
	if current_node:
		if current_node["choices"]:
			var next_node = current_node["choices"][index]
			current_node = dialogue_tree["nodes"][next_node]
			_update()
		else:
			current_node = {}
			print("DialogueController: dialogue ended.")
			hide()
