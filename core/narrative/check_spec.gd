class_name CheckSpec
extends RefCounted
## A check described in dialogue, such as a response tagged
## [#check=wits.moderate] or [#check=blitz.hard, #trap].

const CHECK_TAG := "check"
const TRAP_TAG := "trap"

var ability := AbilityScores.Ability.HITS
var difficulty := "moderate"
var is_trap := false


## Builds a spec from an ability and difficulty name, or returns null if
## either is not recognised.
static func create(ability_name: String, difficulty_name: String, trap := false) -> CheckSpec:
	var index := AbilityScores.Ability.keys().find(ability_name.to_upper())
	if index == -1 or not Check.is_difficulty(difficulty_name):
		push_error("Unknown check: %s.%s" % [ability_name, difficulty_name])
		return null
	var spec := CheckSpec.new()
	spec.ability = index as AbilityScores.Ability
	spec.difficulty = difficulty_name
	spec.is_trap = trap
	return spec


## Reads a spec from a response's tags, or returns null if it has none.
static func from_tags(tags: PackedStringArray) -> CheckSpec:
	var prefix := CHECK_TAG + "="
	for tag: String in tags:
		if tag.begins_with(prefix):
			var parts := tag.trim_prefix(prefix).split(".")
			var difficulty_name := parts[1] if parts.size() > 1 else ""
			return create(parts[0], difficulty_name, tags.has(TRAP_TAG))
	return null


## The target number for this check's difficulty.
func target() -> int:
	return Check.target_for(difficulty)


## The label shown after a choice, such as "Blitz, Moderate". Traps are
## only labelled for heroes whose sign reveals them.
func label(hero: Hero) -> String:
	var text := "%s, %s" % [AbilityScores.display_name(ability), difficulty.capitalize()]
	if is_trap and hero.birth_sign.labels_traps:
		text += ", trap"
	return text
