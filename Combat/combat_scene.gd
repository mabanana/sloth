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
var auto_progress

@onready var auto_toggle: CheckButton = %CheckButton
@onready var combat_log_container: VBoxContainer = %VBoxContainer

const scroll_speed = 0.1

enum Outcome {
	WIN,
	LOSS,
	UNRESOLVED
}

# Called when the node enters the scene tree for the first time.
func _ready():
	player_turn = true
	combat_ended = false
	auto_progress = false
	outcome = Outcome.UNRESOLVED
	main = get_parent()
	init_test()
	start_combat_log_timer(scroll_speed)
	auto_toggle.toggled.connect(func(toggled_on):
		auto_progress = toggled_on
		auto_toggle.release_focus()
	)
	timer.timeout.connect(func():
		if auto_progress:
			progress_turn()
	)

func init_test():
	add_character(CombatCharacter.new("Player", load("res://Combat/CharacterResources/player.tres")))
	add_character(CombatCharacter.new("Bandit", load("res://Combat/CharacterResources/generic_human.tres")))
	character_sprites[2].position = Vector2(300, -100)
	character_sprites[1].position = Vector2(-300, -100)
	characters[2].enemy = true

func _unhandled_input(event):
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
	
	var attack_roll = dealer.attack_roll()
	var damage_roll = dealer.damage_roll()
	
	if not target.alive:
		target.take_damage(damage_roll)
		combat_log("%s dealt %s to %s" % [dealer.name, damage_roll, target.name])
	else:
		var defense_roll = target.defense_roll()
		
		if attack_roll > defense_roll:
			target.take_damage(damage_roll)
			combat_log("%s attacks %s and dealt %s damage" % [dealer.name, target.name, damage_roll])
		else:
			combat_log("%s's attack missed" % [dealer.name])
		if target.hp <= 0:
			combat_log("%s has died" % [target.name])
			target.alive = false
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
		combat_log_container.add_child(label)
		await get_tree().process_frame
		combat_log_container.get_parent().ensure_control_visible(label)
		if combat_log_container.get_child_count() > 30:
			combat_log_container.get_child(0).queue_free()

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
		outcome = Outcome.WIN
		combat_ended = true
	elif !player_alive and enemy_alive:
		outcome = Outcome.LOSS
		combat_ended = true

func progress_turn():
	if combat_ended:
		main.main_menu.show()
		main.conclude_combat(outcome)
		queue_free()
	
	var player_char_list = []
	var enemy_char_list = []
	for char in characters.values():
		if char.alive:
			if char.enemy:
				enemy_char_list.append(char.id)
			else:
				player_char_list.append(char.id)
	# TODO add targeting system, currently just attacking first on list
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
		match Outcome:
			Outcome.WIN:
				combat_log("You Won!")
			Outcome.LOSS:
				combat_log("You Lost.")
			Outcome.UNRESOLVED:
				combat_log("This isn't over.")
		combat_log("Click to continue...")
		auto_toggle.button_pressed = false
	player_turn = !player_turn
