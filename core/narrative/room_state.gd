class_name RoomState
extends RefCounted
## What a room's dialogue can see and change: the hero, checks and flags.
##
## The room passes this to Dialogue Manager as an extra game state, so
## its properties and methods can be used in dialogue by name, such as
## `passed`, `hurt(3)` or `has_class("fighter")`.

signal check_resolved(text: String)
signal hero_changed

var hero: Hero
## Whether the most recent check succeeded.
var passed := false

var _dice: Dice
var _flags: Dictionary[String, bool] = {}


func _init(room_hero: Hero, dice: Dice) -> void:
	hero = room_hero
	_dice = dice


## Rolls a check, adding the hero's sign bonus if it is a trap.
func resolve(spec: CheckSpec) -> CheckResult:
	var modifier := hero.scores.modifier(spec.ability)
	if spec.is_trap:
		modifier += hero.birth_sign.trap_check_bonus
	var result := Check.roll(_dice, modifier, spec.target())
	passed = result.passed()
	check_resolved.emit(result.describe(AbilityScores.display_name(spec.ability) + " check"))
	return result


## A check called from dialogue, such as `$> check("wits", "easy")`.
func check(ability_name: String, difficulty_name: String) -> void:
	var spec := CheckSpec.create(ability_name, difficulty_name)
	if spec != null:
		resolve(spec)


func hurt(amount: int) -> void:
	hero.take_damage(amount)
	hero_changed.emit()


func heal(amount: int) -> void:
	hero.heal(amount)
	hero_changed.emit()


func has_class(id: String) -> bool:
	return hero.character_class.id == StringName(id)


func has_species(id: String) -> bool:
	return hero.species.id == StringName(id)


func has_sign(id: String) -> bool:
	return hero.birth_sign.id == StringName(id)


## Marks something as having happened in this room.
func flag(flag_name: String) -> void:
	_flags[flag_name] = true


func flagged(flag_name: String) -> bool:
	return _flags.has(flag_name)
