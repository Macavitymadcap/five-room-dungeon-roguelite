class_name Check
extends RefCounted
## The core check rule: 2d5 plus a modifier, equal to or over the target wins.

const DICE := 2
const EASY := 6
const MODERATE := 8
const HARD := 10
const DIFFICULTIES: Dictionary[String, int] = {
	"easy": EASY,
	"moderate": MODERATE,
	"hard": HARD,
}


## Rolls a check and returns the full result.
static func roll(dice: Dice, modifier: int, target: int) -> CheckResult:
	return CheckResult.new(dice.roll_each(DICE), modifier, target)


## True for "easy", "moderate" or "hard".
static func is_difficulty(difficulty: String) -> bool:
	return DIFFICULTIES.has(difficulty)


## The target number for a named difficulty.
static func target_for(difficulty: String) -> int:
	return DIFFICULTIES[difficulty]
