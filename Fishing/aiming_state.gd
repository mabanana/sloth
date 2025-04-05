extends State
class_name FishingAimingState

var scene: FishingScene
var cast_power: float
var max_cast_power: float
var min_cast_power: float

func state_process(delta):
	cast_power += delta
	cast_power = min(max_cast_power, cast_power)

func state_input(result):
	if result.context == InputHandler.Context.key_released or result.context == InputHandler.Context.mouse_released:
		if cast_power > min_cast_power:
			var power = cast_power
			next_state = state_machine.states["Casting"]
		else:
			next_state = state_machine.states["Ready"]
			print("cast power too low.")
	if result.context == InputHandler.Context.mouse_moved:
		scene.cast_pos = get_viewport().get_mouse_position()

func on_enter():
	scene = state_machine.scene
	cast_power = 0
	max_cast_power = scene.max_cast_power
	min_cast_power = scene.min_cast_power

func on_exit():
	scene.cast_power = cast_power
	scene.cast_pos = get_viewport().get_mouse_position()
	print("casted rod at %s power" % [cast_power])
