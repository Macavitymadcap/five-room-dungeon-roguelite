class_name ContentLibrary
extends RefCounted
## Loads the game's creation choices from the data folder.
##
## Every .tres file in a folder is loaded and sorted by id. Unlocks will
## filter these lists in slice 7; for now everything found is available.

const SPECIES_DIR := "res://data/species"
const CLASSES_DIR := "res://data/classes"
const SIGNS_DIR := "res://data/signs"


static func species() -> Array[Species]:
	var result: Array[Species] = []
	result.assign(load_all(SPECIES_DIR))
	return result


static func classes() -> Array[CharacterClass]:
	var result: Array[CharacterClass] = []
	result.assign(load_all(CLASSES_DIR))
	return result


static func signs() -> Array[BirthSign]:
	var result: Array[BirthSign] = []
	result.assign(load_all(SIGNS_DIR))
	return result


## Loads every choice resource in a folder, sorted by id.
static func load_all(folder: String) -> Array[CreationChoice]:
	var choices: Array[CreationChoice] = []
	for file: String in ResourceLoader.list_directory(folder):
		if file.ends_with(".tres"):
			choices.append(load(folder.path_join(file)) as CreationChoice)
	choices.sort_custom(_by_id)
	return choices


static func _by_id(a: CreationChoice, b: CreationChoice) -> bool:
	return String(a.id) < String(b.id)
