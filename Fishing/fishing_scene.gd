extends Node2D
class_name FishingScene

var main: Main
var state: FishingState
var cast_power: float = 0
var max_cast_power: float = 3
var minimum_cast_power: float = 0.6
@export var state_label: Label

enum FishingState {
	READY,         # Ready to start fishing
	AIMING,        # Aiming and building cast_power
	CASTING,       # Throwing the line in animation
	BOBBING,       # Line is in the water, waiting for a bite
	REELING,       # Actively reeling in a caught fish
	CAUGHT,        # Evaluating the catch
}

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent()
	add_fish(load("res://Fishing/FishResources/AtlBass.tres"))
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	state_label.text = FishingState.keys()[state]
	if state == FishingState.AIMING:
		cast_power += delta
		cast_power = min(max_cast_power, cast_power)

func get_random_pos(initial = null):
	var view_size: Vector2 = get_viewport_rect().size
	return Vector2(randi_range(0, view_size.x), randi_range(0, view_size.y))

func add_fish(resource):
	var new_fish:Fish = load("res://Fishing/fish.tscn").instantiate()
	new_fish.resource = resource
	new_fish.position = get_random_pos()
	add_child(new_fish)

func _unhandled_input(event):
	var result: Dictionary = main.input_handler.handle_input(event)
	if result and result.context == InputHandler.Context.key_pressed or result.context == InputHandler.Context.mouse_pressed:
		match result["action"]:
			InputHandler.PlayerActions.INTERACT:
				interact()
	if result and result.context == InputHandler.Context.key_released or result.context == InputHandler.Context.mouse_released:
		match result["action"]:
			InputHandler.PlayerActions.INTERACT:
				interact(true)

func interact(is_release = false):
	match state:
		FishingState.READY:
			if not is_release:
				state = FishingState.AIMING
		FishingState.AIMING:
			if is_release:
				if cast_power > minimum_cast_power:
					var power = cast_power
					state = FishingState.CASTING
					cast_power = 0
					cast_rod(power)
				else:
					state = FishingState.READY
					print("cast power too low.")
		FishingState.CASTING:
			state = FishingState.READY
		FishingState.BOBBING:
			state = FishingState.READY
		FishingState.REELING:
			state = FishingState.READY
		FishingState.CAUGHT:
			state = FishingState.READY

func cast_rod(power):
	print("casted rod at %s power" % [power])
	pass
