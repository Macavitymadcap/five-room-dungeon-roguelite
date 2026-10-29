class_name CheckResult
extends RefCounted
## The outcome of one check, with everything needed to show the roll.

var dice: Array[int] = []
var modifier: int = 0
var target: int = 0


func _init(rolled: Array[int], check_modifier: int, check_target: int) -> void:
	dice = rolled
	modifier = check_modifier
	target = check_target


## The dice plus the modifier.
func total() -> int:
	var sum := modifier
	for die: int in dice:
		sum += die
	return sum


## True if the total equals or beats the target.
func passed() -> bool:
	return total() >= target


## How far the total beat the target by; negative on a failure.
func margin() -> int:
	return total() - target


## The roll written out, such as "Wits check: 3 + 4 + 1 = 8 against 8, success".
func describe(label: String) -> String:
	var outcome := "success" if passed() else "failure"
	return "%s: %s = %d against %d, %s" % [label, _sum_text(), total(), target, outcome]


func _sum_text() -> String:
	var parts: Array[String] = []
	for die: int in dice:
		parts.append(str(die))
	var text := " + ".join(parts)
	if modifier > 0:
		text += " + %d" % modifier
	elif modifier < 0:
		text += " - %d" % -modifier
	return text
