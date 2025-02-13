extends Node2D
class_name Main

var input_handler: InputHandler = InputHandler.new()
var current_scene: Node2D
var main_menu: Control
var wins = 0
var losses = 0

enum Scene {
	COMBAT,
	FISHING,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu = %Control
	%StartCombat.pressed.connect(start_combat)
	%AutoCombat.pressed.connect(func():
		%AutoCheck.button_pressed = true
		start_combat()
	)
	%StartFishing.pressed.connect(func():
		start_scene(Scene.FISHING)
	)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_combat():
	main_menu.hide()
	current_scene = load("res://Combat/scene.tscn").instantiate()
	add_child(current_scene)
	if %AutoCheck.button_pressed:
		current_scene.auto_toggle.button_pressed = true

func conclude_combat(outcome):
	if outcome == CombatScene.Outcome.WIN:
		wins += 1
	elif outcome == CombatScene.Outcome.LOSS:
		losses += 1
	elif outcome == CombatScene.Outcome.UNRESOLVED:
		print("unresolved combat")
	%WinLoss.text = str(wins) + "/" + str(losses)

func start_scene(scene: Scene):
	main_menu.hide()
	var resource
	match scene:
		Scene.COMBAT:
			resource = load("res://Combat/scene.tscn")
		Scene.FISHING:
			resource = load("res://Fishing/scene.tscn")
	current_scene = resource.instantiate()
	add_child(current_scene)
	if %AutoCheck.button_pressed:
		current_scene.auto_toggle.button_pressed = true
