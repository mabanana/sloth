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
	bobber = scene.bobber
	move_bobber()
	if scene.catch:
		move_fish(scene.catch)

func on_exit():
	pass
	
func move_bobber():
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(bobber, "position", scene.cast_origin, 0.5)
	await tween.finished
	next_state = state_machine.states["Ready"]

func move_fish(fish):
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(fish, "position", scene.cast_origin, 0.5)
	await tween.finished
	fish.hide()
