extends State
class_name FishingCastingState

func state_process(delta):
	pass

func state_input(result):
	pass

func on_enter():
	next_state = state_machine.states["Ready"]

func on_exit():
	pass
