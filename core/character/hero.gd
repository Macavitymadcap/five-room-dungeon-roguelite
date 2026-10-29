class_name Hero
extends Resource
## A playable character: their choices, scores and current state.

const BASE_HEALTH := 10
const BASE_DEFENCE := 6

@export var species: Species
@export var character_class: CharacterClass
@export var birth_sign: BirthSign
@export var scores: AbilityScores
@export var level: int = 1
@export var glitz: int = 0
@export var max_health: int = 0
@export var health: int = 0


## Creates a level 1 hero at full health.
static func create(
		species_choice: Species,
		class_choice: CharacterClass,
		sign_choice: BirthSign,
		final_scores: AbilityScores,
		starting_glitz: int) -> Hero:
	var hero := Hero.new()
	hero.species = species_choice
	hero.character_class = class_choice
	hero.birth_sign = sign_choice
	hero.scores = final_scores
	hero.glitz = starting_glitz
	hero.max_health = health_for(final_scores)
	hero.health = hero.max_health
	return hero


## Level 1 health: the hits score plus 10.
static func health_for(hero_scores: AbilityScores) -> int:
	return hero_scores.hits + BASE_HEALTH


## Defence before armour: 6 plus the blitz modifier.
static func defence_for(hero_scores: AbilityScores) -> int:
	return BASE_DEFENCE + hero_scores.modifier(AbilityScores.Ability.BLITZ)


## The number enemies must equal or beat to hit this hero.
func defence() -> int:
	return defence_for(scores)


## A one-line description and the key numbers, for display.
func summary() -> String:
	return "%s %s, born under %s\nHealth %d   Defence %d   Glitz %d" % [
		species.display_name, character_class.display_name,
		birth_sign.display_name, max_health, defence(), glitz]
