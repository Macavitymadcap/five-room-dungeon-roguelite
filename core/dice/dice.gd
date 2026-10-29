class_name Dice
extends RefCounted
## Rolls d5s from a single random stream.

const SIDES := 5

var _rng: RandomNumberGenerator


func _init(rng: RandomNumberGenerator) -> void:
	_rng = rng


## Rolls a single d5.
func d5() -> int:
	return _rng.randi_range(1, SIDES)


## Rolls several d5s and returns each result, for showing dice on screen.
func roll_each(count: int) -> Array[int]:
	var results: Array[int] = []
	for _i: int in range(count):
		results.append(d5())
	return results


## Rolls several d5s and returns their total.
func roll(count: int) -> int:
	var total := 0
	for result: int in roll_each(count):
		total += result
	return total
