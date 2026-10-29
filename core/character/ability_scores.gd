class_name AbilityScores
extends Resource
## A character's five ability scores and the modifiers derived from them.

enum Ability { HITS, BLITZ, WITS, WHIZZ, RIZZ }

const DICE_PER_SCORE := 3
const AVERAGE_SCORE := 9
const MIN_SCORE := 3
const MAX_SCORE := 15


@export_range(3, 15) var hits: int = AVERAGE_SCORE
@export_range(3, 15) var blitz: int = AVERAGE_SCORE
@export_range(3, 15) var wits: int = AVERAGE_SCORE
@export_range(3, 15) var whizz: int = AVERAGE_SCORE
@export_range(3, 15) var rizz: int = AVERAGE_SCORE


## Rolls all five scores on 3d5, always in the same order.
static func roll(dice: Dice) -> AbilityScores:
	var scores := AbilityScores.new()
	scores.hits = dice.roll(DICE_PER_SCORE)
	scores.blitz = dice.roll(DICE_PER_SCORE)
	scores.wits = dice.roll(DICE_PER_SCORE)
	scores.whizz = dice.roll(DICE_PER_SCORE)
	scores.rizz = dice.roll(DICE_PER_SCORE)
	return scores


## The modifier for a score: (score - 9) / 2, rounded down.
static func modifier_for(score: int) -> int:
	return floori((score - AVERAGE_SCORE) / 2.0)


## The ability's name for display, such as "Whizz".
static func display_name(ability: Ability) -> String:
	return str(Ability.keys()[ability]).capitalize()


## Returns the score for one ability.
func get_score(ability: Ability) -> int:
	match ability:
		Ability.HITS:
			return hits
		Ability.BLITZ:
			return blitz
		Ability.WITS:
			return wits
		Ability.WHIZZ:
			return whizz
		_:
			return rizz


## Sets the score for one ability.
func set_score(ability: Ability, value: int) -> void:
	match ability:
		Ability.HITS:
			hits = value
		Ability.BLITZ:
			blitz = value
		Ability.WITS:
			wits = value
		Ability.WHIZZ:
			whizz = value
		_:
			rizz = value


## Returns the modifier for one ability.
func modifier(ability: Ability) -> int:
	return modifier_for(get_score(ability))


## Returns an independent copy of these scores.
func copy() -> AbilityScores:
	var result := AbilityScores.new()
	for value: int in Ability.values():
		var ability := value as Ability
		result.set_score(ability, get_score(ability))
	return result
