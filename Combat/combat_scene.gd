extends Node2D
class_name CombatScene

var main: Main
var characters = {} # id: CombatCharacter
var id_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_test():
	add_character(CombatCharacter.new(load("res://Combat/char_resources/player.tres")))
	add_character(CombatCharacter.new(load("res://Combat/char_resources/generic_human.tres")))
	
func add_character(character):
	characters[id_counter] = character
	id_counter += 1


func _input(event):
	var result = main.input_handler.handle_input(event)
