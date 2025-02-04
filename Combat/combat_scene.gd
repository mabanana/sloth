extends Node2D
class_name CombatScene

var main: Main
var characters = {} # id: CombatCharacter
var id_counter = 1
var message_queue = []
var timer = Timer.new()
var turn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	main = get_parent()
	init_test()
	add_child(timer)
	timer.wait_time = 0.08
	timer.start()
	timer.timeout.connect(display_message)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_test():
	add_character(CombatCharacter.new("Player", load("res://Combat/char_resources/player.tres")))
	add_character(CombatCharacter.new("Bandit", load("res://Combat/char_resources/generic_human.tres")))
	
func add_character(character):
	characters[id_counter] = character
	id_counter += 1

func _input(event):
	var result: Dictionary = main.input_handler.handle_input(event)
	if result and result.context == InputHandler.Context.key_pressed or result.context == InputHandler.Context.mouse_pressed:
		match result["action"]:
			InputHandler.PlayerActions.INTERACT:
				if turn:
					handle_attack(1, 2)
				else:
					handle_attack(2, 1)
				turn = !turn

func handle_attack(dealer_id, target_id):
	var dealer: CombatCharacter = characters[dealer_id]
	var target: CombatCharacter = characters[target_id]
	
	if not dealer.alive:
		game_message("%s is dead and cannot attack" % [dealer.name])
		return
	
	game_message("%s attacks %s" % [dealer.name, target.name])
	var attack_roll = dealer.attack_roll()
	var damage_roll = dealer.damage_roll()
	
	if not target.alive:
		target.take_damage(damage_roll)
		game_message("%s dealt %s to %s" % [dealer.name, damage_roll, target.name])
	else:
		var defense_roll = target.defense_roll()
		game_message("Attack Roll: %s, Defense Roll: %s" % [attack_roll, defense_roll])
		if attack_roll > defense_roll:
			target.take_damage(damage_roll)
			game_message("%s dealt %s to %s" % [dealer.name, damage_roll, target.name])
		else:
			game_message("%s's attack missed" % [dealer.name])
		if target.hp <= 0:
			game_message("%s has died" % [target.name])
			target.alive = false
	game_message("%s: %s, %s: %s" % [dealer.name, dealer.hp, target.name, target.hp])

func game_message(text):
	print(text)
	message_queue.append(text)

func display_message():
	if message_queue:
		var text = message_queue.pop_front()
		var label = Label.new()
		label.text = text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		%VBoxContainer.add_child(label)
		if %VBoxContainer.get_child_count() > 20:
			%VBoxContainer.get_child(0).queue_free()
