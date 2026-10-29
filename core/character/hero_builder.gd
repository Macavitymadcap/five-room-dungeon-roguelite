class_name HeroBuilder
extends RefCounted
## Builds a level 1 hero, one creation stage at a time.
##
## Every roll comes from the dice it is given, in a fixed order: the
## five scores, then glitz, then any rerolls in the order they are made.

signal changed

const GLITZ_BASE := 5
const REROLL_COST := 1
const MIN_GLITZ := 2

var species: Species
var character_class: CharacterClass
var birth_sign: BirthSign
var scores: AbilityScores
var glitz: int = 0

var _dice: Dice
var _has_bonus := false
var _bonus_ability := AbilityScores.Ability.HITS


func _init(dice: Dice) -> void:
	_dice = dice


func choose_species(choice: Species) -> void:
	species = choice
	_has_bonus = false
	changed.emit()


func choose_class(choice: CharacterClass) -> void:
	character_class = choice
	changed.emit()


func choose_sign(choice: BirthSign) -> void:
	birth_sign = choice
	changed.emit()


## Rolls all five scores on 3d5, then glitz on 1d5 + 5.
func roll() -> void:
	scores = AbilityScores.roll(_dice)
	glitz = _dice.d5() + GLITZ_BASE
	_has_bonus = false
	changed.emit()


## True if paying for a reroll would leave at least the minimum glitz.
func can_reroll() -> bool:
	return scores != null and glitz - REROLL_COST >= MIN_GLITZ


## Rerolls one score for 1 glitz. The new roll stands, even if lower.
func reroll(ability: AbilityScores.Ability) -> bool:
	if not can_reroll():
		return false
	scores.set_score(ability, _dice.roll(AbilityScores.DICE_PER_SCORE))
	glitz -= REROLL_COST
	if _has_bonus and _bonus_ability == ability:
		_has_bonus = false
	changed.emit()
	return true


## True if the species grants a bonus point to place.
func offers_bonus() -> bool:
	return species != null and species.ability_bonus > 0


## True if the bonus can go on this ability without passing the maximum.
func can_choose_bonus(ability: AbilityScores.Ability) -> bool:
	return offers_bonus() and scores != null \
			and scores.get_score(ability) < AbilityScores.MAX_SCORE


## Places the species bonus on one ability, replacing any earlier choice.
func choose_bonus(ability: AbilityScores.Ability) -> bool:
	if not can_choose_bonus(ability):
		return false
	_has_bonus = true
	_bonus_ability = ability
	changed.emit()
	return true


## The scores with any species bonus applied.
func final_scores() -> AbilityScores:
	var result := scores.copy()
	if _has_bonus:
		var boosted := result.get_score(_bonus_ability) + species.ability_bonus
		result.set_score(_bonus_ability, boosted)
	return result


## True once every stage is done, including placing any bonus.
func is_complete() -> bool:
	var chosen := species != null and character_class != null and birth_sign != null
	return chosen and scores != null and (_has_bonus or not offers_bonus())


## Returns the finished hero, or null if creation is not complete.
func build() -> Hero:
	if not is_complete():
		return null
	return Hero.create(species, character_class, birth_sign, final_scores(), glitz)
