extends State
class_name FishingCaughtState

func state_process(delta):
	next_state = state_machine.states["Ready"]

func state_input(result):
	pass

func on_enter():
	pass

func on_exit():
	pass
