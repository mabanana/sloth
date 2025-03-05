extends Control
class_name DialogueController

# TODO: Implement state machine when adding animations and other effects
var main: Main

var dialogue_tree: Dictionary
var current_node: Dictionary
var json_parser: JsonParser
var input_handler: InputHandler
var json_path: String
var text_index: int
var text_speed: int = 3
const min_text_speed: int = 0
const max_text_speed: int = 3
var text_cd: int = 0

@export var text_label: Label
@export var speaker_label: Label
@export var end_label: Label
@export var text_speed_slider: HSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	text_index = 0
	json_parser = main.json_parser
	input_handler = main.input_handler
	_init_text_speed_slider()

func _process(delta):
	if current_node:
		_update_text()
		end_label.visible = !len(current_node.choices) and text_index >= len(current_node.text)

func _gui_input(event):
	var result: Dictionary = input_handler.handle_input(event)
	if result:
		if result.context == InputHandler.Context.key_pressed or result.context == InputHandler.Context.mouse_pressed:
			if current_node and text_index <= len(current_node.text) - 1:
				text_label.text = current_node.text
				text_index = len(current_node.text) - 1
			else:
				next_node()

func start(json_path):
	show()
	dialogue_tree = json_parser.load_json(json_path)
	if dialogue_tree and dialogue_tree.nodes["start"]:
		current_node = dialogue_tree.nodes["start"]
	_update()

func _update():
	speaker_label.text = current_node.speaker

func next_node(index = 0):
	if current_node:
		if current_node.choices:
			var next_node = current_node.choices[index]
			current_node = dialogue_tree.nodes[next_node]
			text_index = 0
			_update()
		else:
			current_node = {}
			print("DialogueController: dialogue ended.")
			hide()

func next_character(text: String, label: Label = text_label):
	if text_index <= len(text) - 1:
		text_index += 1
		label.text = text.substr(0, text_index)

func _init_text_speed_slider():
	text_speed_slider.min_value = min_text_speed
	text_speed_slider.max_value = max_text_speed
	text_speed_slider.value = text_speed
	text_speed_slider.drag_ended.connect(func(value_changed):
		text_speed = text_speed_slider.value
		print("text speed set to %s" % [text_speed])
		)

func _update_text():
	if text_cd <= 0:
		next_character(current_node.text)
		if text_speed == 3:
			next_character(current_node.text)
		text_cd = max_text_speed - text_speed
	else:
		text_cd -= 1
