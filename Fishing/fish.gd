extends Node2D
class_name Fish

var resource: FishResource
@export var sprite: Sprite2D
@export var name_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	if not resource:
		queue_free()
	name_label.text = resource.name
	name_label.position.y -= sprite.get_rect().size.y * sprite.scale.y
	print(sprite.get_rect())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
