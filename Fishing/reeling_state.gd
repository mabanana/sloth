extends State
class_name FishingReelingState

var scene: FishingScene
var bobber: Sprite2D

func state_process(delta):
	pass

func state_input(result):
	pass

func on_enter():
	scene = state_machine.scene
	bobber = scene.cast_bobber
	move_to(scene.cast_origin)

func on_exit():
	pass
	
func move_to(pos):
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(bobber, "position", pos, 0.5)
	await tween.finished
	next_state = state_machine.states["Ready"]
