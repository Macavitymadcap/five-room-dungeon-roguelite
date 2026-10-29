extends GdUnitTestSuite
## Tests for CheckSpec: reading check tags and labelling choices.


func test_from_tags_reads_ability_and_difficulty() -> void:
	# Arrange
	var tags := PackedStringArray(["check=wits.moderate"])

	# Act
	var spec := CheckSpec.from_tags(tags)

	# Assert
	assert_int(spec.ability).is_equal(AbilityScores.Ability.WITS)
	assert_int(spec.target()).is_equal(Check.MODERATE)
	assert_bool(spec.is_trap).is_false()


func test_from_tags_reads_the_trap_tag() -> void:
	# Arrange
	var tags := PackedStringArray(["check=blitz.hard", "trap"])

	# Act
	var spec := CheckSpec.from_tags(tags)

	# Assert
	assert_bool(spec.is_trap).is_true()


func test_from_tags_without_a_check_gives_null() -> void:
	# Arrange
	var tags := PackedStringArray(["mood=grumpy"])

	# Act
	var spec := CheckSpec.from_tags(tags)

	# Assert
	assert_object(spec).is_null()


func test_label_hides_traps_from_most_signs() -> void:
	# Arrange
	var spec := CheckSpec.create("blitz", "moderate", true)
	var hero := _make_hero(false)

	# Act
	var label := spec.label(hero)

	# Assert
	assert_str(label).is_equal("Blitz, Moderate")


func test_label_shows_traps_to_signs_that_reveal_them() -> void:
	# Arrange
	var spec := CheckSpec.create("blitz", "moderate", true)
	var hero := _make_hero(true)

	# Act
	var label := spec.label(hero)

	# Assert
	assert_str(label).is_equal("Blitz, Moderate, trap")


func _make_hero(labels_traps: bool) -> Hero:
	var birth_sign := BirthSign.new()
	birth_sign.labels_traps = labels_traps
	return Hero.create(Species.new(), CharacterClass.new(), birth_sign, AbilityScores.new(), 8)
