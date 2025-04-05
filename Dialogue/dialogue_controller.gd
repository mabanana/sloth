extends Control
class_name DialogueController

# TODO: Implement state machine when adding animations and other effects
var main: Main

var dialogue_tree: Dictionary
var current_node: Dictionary
var current_line: int
var current_text: String
var current: Dictionary
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
@export var thumbnail_vbox: VBoxContainer
@export var choices_vbox: VBoxContainer
@export var choices_container: MarginContainer
@export var dialogue_container: PanelContainer
@export var state_machine: StateMachine

signal choice_selected
signal dialogue_ended
signal dialogue_started
signal dialogue_advanced

# Called when the node enters the scene tree for the first time.
func _ready():
	text_index = 0
	input_handler = main.input_handler
	clear_children(choices_vbox)
	connect_signals()

func connect_signals():
	dialogue_started.connect(_init_text_speed_slider)
	dialogue_advanced.connect(_update_current)
	dialogue_advanced.connect(_update_choices)
	dialogue_ended.connect(_on_dialogue_end)

func _process(delta):
	if current_node:
		text_animation_tick()
		end_label.visible = (
			!len(current_node.choices)
			and text_index >= len(current.text) 
			and current_line >= len(current_node.dialogue) - 1)

func _gui_input(event):
	var result: Dictionary = input_handler.handle_input(event)
	if result:
		if result.context == InputHandler.Context.mouse_pressed:
			if current_node and text_index <= len(current.text) - 1:
				text_label.text = current.text
				text_index = len(current.text) - 1
			else:
				advance()
func _input(event):
	var result: Dictionary = input_handler.handle_input(event)
	if result:
		if (current_node and len(current_node.choices) > 1 and current_line >= len(current_node.dialogue) - 1):
			if result.context == InputHandler.Context.key_pressed and result.action in [InputHandler.PlayerActions.SELECT_SlOT_1,
			InputHandler.PlayerActions.SELECT_SlOT_2,
			InputHandler.PlayerActions.SELECT_SlOT_3,
			InputHandler.PlayerActions.SELECT_SlOT_4]:
				var selection = result.action - InputHandler.PlayerActions.SELECT_SlOT_1
				next_node(selection)
		elif result.context == InputHandler.Context.key_pressed:
			if current_node and text_index <= len(current.text) - 1:
				text_label.text = current.text
				text_index = len(current.text) - 1
			else:
				advance()

func start(json_path):
	show()
	dialogue_tree = JsonParser.load_json(json_path)
	if dialogue_tree and dialogue_tree.nodes["start"]:
		current_node = dialogue_tree.nodes["start"]
	dialogue_started.emit()
	dialogue_advanced.emit()

func advance():
	if current_line < len(current_node.dialogue) - 1:
		current_line += 1
		dialogue_advanced.emit()
	elif current_node and current_node.choices:
		next_node()
	elif current_node:
		print("DialogueController: dialogue ended.")
		dialogue_ended.emit()
	else:
		print("DialogueController: no current dialogue")

func next_node(index = -1):
	if len(current_node.choices) == 1:
		index = 0
	
	if index >= 0:
		var next_node = current_node.choices[index]
		current_node = dialogue_tree.nodes[next_node]
		current_line = 0
		dialogue_advanced.emit()

func _init_text_speed_slider():
	text_speed_slider.min_value = min_text_speed
	text_speed_slider.max_value = max_text_speed
	text_speed_slider.value = text_speed
	text_speed_slider.drag_ended.connect(func(value_changed):
		text_speed = text_speed_slider.value
		print("text speed set to %s" % [text_speed])
		)

func next_character(text: String, label: Label = text_label):
	if text_index <= len(text) - 1:
		text_index += 1
		label.text = text.substr(0, text_index)
		
func text_animation_tick():
	if text_cd <= 0:
		next_character(current.text)
		if text_speed == 3:
			next_character(current.text)
		text_cd = max_text_speed - text_speed
	else:
		text_cd -= 1

func _update_current():
	current = current_node.dialogue[str(current_line)]
	current_text = current.text
	speaker_label.text = current.speaker
	thumbnail_vbox.visible = len(current.speaker) > 0
	text_index = 0

func _update_choices():
	if (current_node and len(current_node.choices) > 1 
	and current_line >= len(current_node.dialogue) - 1):
		clear_children(choices_vbox)
		choices_container.show()
		for i in range(len(current_node.choices)):
			var button = Button.new()
			button.text = str(i+1) + ". "
			button.text += current_node.choices[i].capitalize()
			button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			button.flat = true
			choices_vbox.add_child(button)
			button.pressed.connect(next_node.bind(i))
	else:
		choices_container.hide()
		
func _on_dialogue_end():
	dialogue_tree = {}
	current_node = {}
	current_line = 0
	current_text= ""
	hide()

static func clear_children(node: Node):
	for child in node.get_children():
		child.queue_free()
