extends State
class_name FishingCastingState
var scene: FishingScene
var cast_pos: Vector2
var bobber: Sprite2D

func state_process(delta):
	pass

func state_input(result):
	pass

func on_enter():
	scene = state_machine.scene
	bobber = scene.cast_bobber
	bobber.position = scene.cast_origin
	
	var max_cast_dist = scene.cast_origin.length() / 2 * (scene.cast_power/scene.max_cast_power)
	var displace = scene.cast_pos - scene.cast_origin
	displace = displace.normalized() * min(displace.length(), max_cast_dist)
	
	move_to(scene.cast_origin + displace)

func on_exit():
	pass

func move_to(pos):
	var scale = bobber.scale
	var tween:Tween = get_tree().create_tween()
	var tween2:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property(bobber, "position", pos, 1)
	
	
	tween2.tween_property(bobber, "scale", scale * 1.5, 0.2)
	tween2.set_trans(Tween.TRANS_CIRC)
	tween2.tween_property(bobber, "scale", scale, 0.8)
	await tween.finished
	next_state = state_machine.states["Bobbing"]
