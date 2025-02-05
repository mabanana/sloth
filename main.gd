extends Node2D
class_name Main

var input_handler: InputHandler = InputHandler.new()
var current_scene: Node2D
var main_menu: Control
var wins = 0
var losses = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu = %Control
	%Start_Combat.pressed.connect(start_combat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_combat():
	main_menu.hide()
	current_scene = load("res://Combat/scene.tscn").instantiate()
	add_child(current_scene)
	if %CheckButton.button_pressed:
		current_scene.auto_toggle.button_pressed = true

func conclude_combat(outcome):
	if outcome == CombatScene.Outcome.win:
		wins += 1
	elif outcome == CombatScene.Outcome.loss:
		losses += 1
	elif outcome == CombatScene.Outcome.unresolved:
		print("unresolved combat")
	%WinLoss.text = str(wins) + "/" + str(losses)
