extends Object
class_name CombatCharacter

static var attack_dice = 20
static var base_damage_dice = 4

# identifiers
var id: int
var name: String
var type: String
var enemy: bool

# stats
var hp: int
var morale: int
var toxicity: int
var melee_skill: int
var ranged_skill: int
var defense: int
var reflex: int

# data
var resource: CharacterResource
var statuses: Array
var equips: Array

# state
var alive: bool

var max_hp: int:
	get:
		return resource.hp
var max_morale: int:
	get:
		return resource.morale
var max_toxicity: int:
	get:
		return resource.toxicity
var base_melee_skill: int:
	get:
		return resource.melee_skill
var base_ranged_skill: int:
	get:
		return resource.ranged_skill
var base_defense: int:
	get:
		return resource.defense
var base_reflex: int:
	get:
		return resource.reflex

func _init(name, resource: CharacterResource):
	self.resource = resource
	self.type = resource.name
	self.name = name
	self.enemy = false
	
	self.melee_skill = resource.melee_skill
	self.ranged_skill = resource.ranged_skill
	self.defense = resource.defense
	self.reflex = resource.reflex
	
	self.hp = resource.hp
	self.morale = resource.morale
	self.toxicity = resource.toxicity

	self.statuses = []
	self.equips = []
	
	self.alive = true

func attack_roll():
	var roll = randi_range(1, attack_dice) + melee_skill
	return roll

func defense_roll():
	var roll = randi_range(1, attack_dice) + defense
	return roll

func damage_roll():
	var roll = randi_range(1, base_damage_dice)
	return roll

func take_damage(amount):
	hp -= amount
