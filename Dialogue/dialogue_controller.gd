extends Control
class_name DialogueController

var dialogue_tree: Dictionary
var current_node: Dictionary
var json_parser: JsonParser

@export var text_label: Label
@export var speaker_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	json_parser = JsonParser.new()
	dialogue_tree = json_parser.load_json("res://Dialogue/test_dialogue.json")
	start()
	get_tree().create_timer(2).timeout.connect(func(): next_node(0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	if dialogue_tree and dialogue_tree["nodes"]["start"]:
		current_node = dialogue_tree["nodes"]["start"]
	_update()

func _update():
	text_label.text = current_node["text"]
	speaker_label.text = current_node["speaker"]

func next_node(index = 0):
	if current_node:
		if current_node["choices"]:
			var next_node = current_node["choices"][index]
			current_node = dialogue_tree["nodes"][next_node]
			_update()
			get_tree().create_timer(2).timeout.connect(func(): next_node(0))
		else:
			current_node = {}
			print("DialogueController: dialogue ended.")
