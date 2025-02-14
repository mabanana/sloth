extends Node2D
class_name FishingScene

var main: Main
@export var state_machine: StateMachine

var cast_origin: Vector2
var default_cast: Vector2
var cast_pos: Vector2
var max_fish_move = 300
var cast_power: float = 0
var max_cast_power: float = 1.5
var min_cast_power: float = 0.6
@export var state_label: Label
@export var cast_bobber: Sprite2D

func _ready():
	main = get_parent()
	add_fish(load("res://Fishing/FishResources/AtlBass.tres"))
	var view_size: Vector2 = get_viewport_rect().size
	
	cast_origin = Vector2(int(view_size.x / 2), int(view_size.y * 0.9))
	default_cast = Vector2(int(view_size.x / 2), int(view_size.y / 2))
	cast_pos = default_cast
	cast_bobber.position = cast_origin

func _unhandled_input(event):
	var result: Dictionary = main.input_handler.handle_input(event)
	if result:
		state_machine.state_machine_input(result)

func _process(delta):
	state_label.text = state_machine.current_state.name
	state_machine.state_machine_process(delta)

func get_random_pos(initial = null):
	var view_size: Vector2 = get_viewport_rect().size
	var pos = Vector2(randi_range(0, view_size.x), randi_range(0, view_size.y))
	if initial:
		var displace:Vector2 = pos - initial
		var dist = displace.length()
		displace = displace.normalized() * min(dist, max_fish_move)
		pos = initial + displace
	return pos

func add_fish(resource):
	var new_fish:Fish = load("res://Fishing/fish.tscn").instantiate()
	new_fish.resource = resource
	new_fish.position = get_random_pos()
	add_child(new_fish)
	new_fish.move_to(get_random_pos(new_fish.position))
	new_fish.move_done.connect(_on_fish_move_end)

func _on_fish_move_end(fish):
	fish.move_to(get_random_pos(fish.position))
