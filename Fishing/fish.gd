extends Node2D
class_name Fish

var resource: FishResource
@export var sprite: Sprite2D
@export var name_label: Label

signal move_done
var is_biting = false
var caught = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not resource:
		queue_free()
	name_label.text = resource.name
	name_label.position.y -= sprite.get_rect().size.y * sprite.scale.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move_to(pos):
	if caught:
		return
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position", pos, randf_range(2,4))
	await tween.finished
	emit_signal("move_done", self)
