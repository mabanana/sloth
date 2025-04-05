extends State
class_name DialogueGameActionsState
# awaits signal for code outside of dialogue to resolve
# handles input to skip if time based
# exits into typing or idle

var action_complete: Signal
var scene: DialogueController

func state_process(delta):
	pass

func state_input(result):
	pass

func on_enter():
	pass

func on_exit():
	pass
