extends Node2D
class_name Main

var input_handler: InputHandler = InputHandler.new()
var json_parser: JsonParser = JsonParser.new()
var dialog_controller: DialogueController
var current_scene: Node2D
var main_menu: Control
var wins = 0
var losses = 0

@export var canvas_layer: CanvasLayer

enum Scene {
	COMBAT,
	FISHING,
	MAP,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	init_dialogue_controller()
	main_menu = %Control
	%StartCombat.pressed.connect(func():
		start_combat()
		%AutoCombat.release_focus()
	)
	%AutoCombat.pressed.connect(func():
		%AutoCheck.button_pressed = true
		start_combat()
		%AutoCombat.release_focus()
	)
	%StartFishing.pressed.connect(func():
		start_scene(Scene.FISHING)
		%StartFishing.release_focus()
	)
	%StartDialogue.pressed.connect(func():
		dialog_controller.start("res://Dialogue/test_dialogue.json")
		%StartDialogue.release_focus()
	)
	%OpenMap.pressed.connect(func():
		start_scene(Scene.MAP)
		%OpenMap.release_focus()
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
		Scene.MAP:
			resource = load("res://GridRPG/scene.tscn")
	current_scene = resource.instantiate()
	add_child(current_scene)
	if %AutoCheck.button_pressed and scene == Scene.COMBAT:
		current_scene.auto_toggle.button_pressed = true

func init_dialogue_controller():
	if not dialog_controller:
		dialog_controller = load("res://Dialogue/dialogue_controller.tscn").instantiate()
		dialog_controller.main = self
		dialog_controller.hide()
		canvas_layer.add_child(dialog_controller)
