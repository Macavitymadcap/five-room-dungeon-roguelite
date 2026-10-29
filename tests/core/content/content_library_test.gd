extends GdUnitTestSuite
## Tests for ContentLibrary, against the real files in res://data.


func test_species_includes_human() -> void:
	# Arrange
	var expected: Array[StringName] = [&"human"]

	# Act
	var ids := _ids(ContentLibrary.species())

	# Assert
	assert_array(ids).contains(expected)


func test_classes_include_fighter() -> void:
	# Arrange
	var expected: Array[StringName] = [&"fighter"]

	# Act
	var ids := _ids(ContentLibrary.classes())

	# Assert
	assert_array(ids).contains(expected)


func test_signs_include_bureaucracy() -> void:
	# Arrange
	var expected: Array[StringName] = [&"bureaucracy"]

	# Act
	var ids := _ids(ContentLibrary.signs())

	# Assert
	assert_array(ids).contains(expected)


func test_human_grants_one_bonus_point() -> void:
	# Arrange
	var all_species := ContentLibrary.species()

	# Act
	var human: Species = all_species.filter(
			func(s: Species) -> bool: return s.id == &"human")[0]

	# Assert
	assert_int(human.ability_bonus).is_equal(1)


func _ids(choices: Array) -> Array[StringName]:
	var ids: Array[StringName] = []
	for choice: CreationChoice in choices:
		ids.append(choice.id)
	return ids
