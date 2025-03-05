extends Node
class_name StateMachine

@export var current_state : State
@export var scene: Node2D
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
				states[child.name] = child
				# Set the state up with what they need to function
				child.state_machine = self
		else:
			push_warning("CharacterStateMachine:  " + child.name + " is not a State for CharacterStateMachine")

func state_machine_process(delta):
	if current_state.next_state != null:
		print(str(scene.name) + " has entered " + str(current_state.next_state.name) + " from " + str(current_state.name))
		switch_states(current_state.next_state)
	current_state.state_process(delta)

func state_machine_input(result):
	current_state.state_input(result)

func switch_states(new_state: State):
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
	current_state = new_state
	current_state.on_enter()
	
