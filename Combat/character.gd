extends Object
class_name CombatCharacter

var name: String

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

func _init(resource: CharacterResource):
	self.resource = resource
	name = resource.name
	melee_skill = resource.melee_skill
	ranged_skill = resource.ranged_skill
	defense = resource.defense
	reflex = resource.reflex
	
	hp = resource.hp
	morale = resource.morale
	toxicity = resource.toxicity

	statuses = []
	equips = []
