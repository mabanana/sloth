extends Node2D
class_name CharacterSprite

@onready var health_bar: ProgressBar = %ProgressBar
@onready var name_label: Label = %Name
@onready var hp_label: Label = %HpValue
var character: CombatCharacter

# Called when the node enters the scene tree for the first time.
func _ready():
	health_bar.show_percentage = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update():
	health_bar.max_value = character.max_hp
	health_bar.value = character.hp
	var hp_string = str(character.hp) + "/" + str(character.max_hp)
	hp_label.text = hp_string
	name_label.text = character.name
