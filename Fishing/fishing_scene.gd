extends Node2D
class_name FishingScene

# Called when the node enters the scene tree for the first time.
func _ready():
	add_fish(load("res://Fishing/FishResources/AtlBass.tres"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_random_pos(initial = null):
	var view_size: Vector2 = get_viewport_rect().size
	return Vector2(randi_range(0, view_size.x), randi_range(0, view_size.y))

func add_fish(resource):
	var new_fish:Fish = load("res://Fishing/fish.tscn").instantiate()
	new_fish.resource = resource
	new_fish.position = get_random_pos()
	add_child(new_fish)
