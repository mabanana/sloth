extends State
class_name FishingBobbingState

var scene: FishingScene
var bobber: Sprite2D

func state_process(delta):
	pass

func state_input(result):
	if result and result.context == InputHandler.Context.key_pressed or result.context == InputHandler.Context.mouse_pressed:
		match result["action"]:
			InputHandler.PlayerActions.INTERACT:
				next_state = state_machine.states["Reeling"]

func on_enter():
	scene = state_machine.scene
	bobber = scene.cast_bobber

func on_exit():
	pass
