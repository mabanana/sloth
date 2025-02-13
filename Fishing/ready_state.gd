extends State
class_name FishingReadyState

func state_process(delta):
	pass

func state_input(result):
	if result and result.context == InputHandler.Context.key_pressed or result.context == InputHandler.Context.mouse_pressed:
		match result["action"]:
			InputHandler.PlayerActions.INTERACT:
				next_state = state_machine.states["Aiming"]

func on_enter():
	pass

func on_exit():
	pass
