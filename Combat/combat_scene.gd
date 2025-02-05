extends Node2D
class_name CombatScene

var main: Main
var characters = {} # id: CombatCharacter
var character_sprites = {} # id: CharacterSprite
var id_counter = 1
var message_queue = []
var timer = Timer.new()
var player_turn
var combat_ended
var outcome

const scroll_speed = 0.08

enum Outcome {
	win,
	lose,
	tie,
	run,
	none,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	player_turn = true
	combat_ended = false
	outcome = Outcome.none
	main = get_parent()
	init_test()
	start_combat_log_timer(scroll_speed)
	

func init_test():
	add_character(CombatCharacter.new("Player", load("res://Combat/char_resources/player.tres")))
	add_character(CombatCharacter.new("Bandit", load("res://Combat/char_resources/generic_human.tres")))
	character_sprites[2].position = Vector2(200,100)
	character_sprites[1].position = Vector2(-200,100)
	characters[2].enemy = true

func _input(event):
	var result: Dictionary = main.input_handler.handle_input(event)
	if result and result.context == InputHandler.Context.key_pressed or result.context == InputHandler.Context.mouse_pressed:
		match result["action"]:
			InputHandler.PlayerActions.INTERACT:
				progress_turn()

func handle_attack(dealer, target):
	var dealer_sprite: CharacterSprite = character_sprites[dealer.id]
	var target_sprite: CharacterSprite = character_sprites[target.id]
	
	if not dealer.alive:
		combat_log("%s is dead and cannot attack" % [dealer.name])
		return
	
	combat_log("%s attacks %s" % [dealer.name, target.name])
	var attack_roll = dealer.attack_roll()
	var damage_roll = dealer.damage_roll()
	
	if not target.alive:
		target.take_damage(damage_roll)
		combat_log("%s dealt %s to %s" % [dealer.name, damage_roll, target.name])
	else:
		var defense_roll = target.defense_roll()
		combat_log("Attack Roll: %s, Defense Roll: %s" % [attack_roll, defense_roll])
		if attack_roll > defense_roll:
			target.take_damage(damage_roll)
			combat_log("%s dealt %s to %s" % [dealer.name, damage_roll, target.name])
		else:
			combat_log("%s's attack missed" % [dealer.name])
		if target.hp <= 0:
			combat_log("%s has died" % [target.name])
			target.alive = false
	combat_log("%s: %s, %s: %s" % [dealer.name, dealer.hp, target.name, target.hp])
	dealer_sprite.update()
	target_sprite.update()

func combat_log(text):
	print(text)
	message_queue.append(text)
	
func start_combat_log_timer(scroll_speed):
	add_child(timer)
	timer.wait_time = scroll_speed
	timer.start()
	timer.timeout.connect(_print_combat_log)

func _print_combat_log():
	if message_queue:
		var text = message_queue.pop_front()
		var label = Label.new()
		label.text = text
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		%VBoxContainer.add_child(label)
		if %VBoxContainer.get_child_count() > 20:
			%VBoxContainer.get_child(0).queue_free()

func add_character(character):
	characters[id_counter] = character
	character.id = id_counter
	add_character_sprite(character, id_counter)
	id_counter += 1

func add_character_sprite(character: CombatCharacter, id):
	var sprite: CharacterSprite = load("res://Combat/character_sprite.tscn").instantiate()
	sprite.character = character
	add_child(sprite)
	character_sprites[id] = sprite
	sprite.update()

func check_win():
	var player_alive = false
	var enemy_alive = false
	for char in characters.values():
		if char.alive:
			if char.enemy:
				enemy_alive = true
			else:
				player_alive = true
	if player_alive and !enemy_alive:
		outcome = Outcome.win
		combat_ended = true
	elif !player_alive and enemy_alive:
		outcome = Outcome.lose
		combat_ended = true

func progress_turn():
	if combat_ended:
		queue_free()
	
	var player_char_list = []
	var enemy_char_list = []
	for char in characters.values():
		if char.alive:
			if char.enemy:
				enemy_char_list.append(char.id)
			else:
				player_char_list.append(char.id)

	if player_turn:
		for id in player_char_list:
			var dealer: CombatCharacter = characters[id]
			var target: CombatCharacter = characters[enemy_char_list[0]]
			handle_attack(dealer, target)
	else:
		for id in enemy_char_list:
			var dealer: CombatCharacter = characters[id]
			var target: CombatCharacter = characters[player_char_list[0]]
			handle_attack(dealer, target)
	check_win()
	if combat_ended:
		combat_log("Combat ended in %s.\nClick to continue..." % [Outcome.keys()[outcome]])
	player_turn = !player_turn
