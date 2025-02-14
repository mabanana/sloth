extends Node2D
class_name FishingScene

var main: Main
@export var state_machine: StateMachine

var types = ["Atlantic Bass",
		"Clownfish",
		"Dab",
		"Sea Spider",
		"Blue Gill",
		"Guppy",
		"Freshwater Snail",
		"Axolotl",
		"High Fin",
		"Golden Tench",
		"Moss Ball",
		"Plastic Bag",
		"Junonia",
		"Sand Dollar",
		"Starfish",
		"Bobber"
		]

var cast_origin: Vector2
var default_cast: Vector2
var cast_pos: Vector2

var bite_chance = 0.3
var max_fish_move = 300
var cast_power: float = 0
var max_cast_power: float = 1.5
var min_cast_power: float = 0.6
var fishes = {}
var fish_counter = 1
var catch: Fish = null

@export var state_label: Label
@export var bobber: Sprite2D

func _ready():
	main = get_parent()
	
	for i in range(10):
		add_fish(randi_range(0, len(types) - 2))
	
	var view_size: Vector2 = get_viewport_rect().size
	
	cast_origin = Vector2(int(view_size.x / 2), int(view_size.y * 0.9))
	default_cast = Vector2(int(view_size.x / 2), int(view_size.y / 2))
	cast_pos = default_cast
	bobber.position = cast_origin

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

func add_fish(sprite_frame):
	var new_fish:Fish = load("res://Fishing/fish.tscn").instantiate()
	new_fish.sprite_frame = sprite_frame
	new_fish.type = types[sprite_frame]
	new_fish.position = get_random_pos()
	add_child(new_fish)
	fishes[fish_counter] = new_fish
	fish_counter += 1
	new_fish.move_to(get_random_pos(new_fish.position))
	new_fish.move_done.connect(_on_fish_move_end)

func _on_fish_move_end(fish:Fish):
	if fish.is_biting:
		fish.is_biting = false
		fish.move_to(get_random_pos(fish.position))
		return
	
	if ((fish.position - bobber.position).length() < max_fish_move 
	and state_machine.current_state is FishingBobbingState):
		var roll = randf()
		if roll < bite_chance:
			fish.move_to(bobber.position)
			print("bite!")
			fish.is_biting = true
			return
	fish.move_to(get_random_pos(fish.position))

func catch_fish(fish: Fish):
	fish.caught = true
	fish.is_biting = false
	catch = fish
	print("caught %s" % [fish.type])
