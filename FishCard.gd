extends Control
class_name FishCard

@export var type_label: Label
@export var length_num: Label
@export var length_unit: Label
@export var weight_num: Label
@export var weight_unit: Label
@export var record_label: Label
@export var fish_icon: TextureRect

var length: float
var weight: float
var type: String
var frame_x: int
var frame_y: int
var new_fish: bool = false
var new_record: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():	
	if not length or not weight or not type:
		print("missing data on fish card.")
		queue_free()
	length_num.text = str(length)
	weight_num.text = str(weight)
	type_label.text = type
	var atlas:AtlasTexture = fish_icon.texture
	atlas.set("region", Rect2(frame_x, frame_y, 16, 16))
	
	if new_fish:
		record_label.text = "New Fish Caught!!"
	elif new_record:
		record_label.text = "New Record!!"
	else:
		record_label.hide()
	
	gui_input.connect(_on_card_clicked)
	get_tree().create_timer(1.5).timeout.connect(queue_free)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_clicked(event: InputEvent):
	if event.is_pressed():
		queue_free()
