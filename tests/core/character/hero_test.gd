extends GdUnitTestSuite
## Tests for Hero: derived values at creation and the summary.


func test_create_sets_full_health_from_hits() -> void:
	# Arrange
	var scores := AbilityScores.new()
	scores.hits = 12

	# Act
	var hero := _make_hero(scores)

	# Assert
	assert_int(hero.max_health).is_equal(22)
	assert_int(hero.health).is_equal(22)


func test_create_starts_at_level_one() -> void:
	# Arrange
	var scores := AbilityScores.new()

	# Act
	var hero := _make_hero(scores)

	# Assert
	assert_int(hero.level).is_equal(1)


@warning_ignore("unused_parameter")
func test_defence_uses_blitz_modifier(blitz: int, expected: int, test_parameters := [
		[3, 3], [9, 6], [15, 9]]) -> void:
	# Arrange
	var scores := AbilityScores.new()
	scores.blitz = blitz
	var hero := _make_hero(scores)

	# Act
	var actual := hero.defence()

	# Assert
	assert_int(actual).is_equal(expected)


func test_summary_names_the_choices() -> void:
	# Arrange
	var hero := _make_hero(AbilityScores.new())

	# Act
	var actual := hero.summary()

	# Assert
	assert_str(actual).starts_with("Human Fighter, born under Bureaucracy")


func _make_hero(scores: AbilityScores) -> Hero:
	var species := Species.new()
	species.display_name = "Human"
	var character_class := CharacterClass.new()
	character_class.display_name = "Fighter"
	var birth_sign := BirthSign.new()
	birth_sign.display_name = "Bureaucracy"
	return Hero.create(species, character_class, birth_sign, scores, 8)


func test_take_damage_stops_at_zero() -> void:
	# Arrange
	var hero := _make_hero(AbilityScores.new())

	# Act
	hero.take_damage(100)

	# Assert
	assert_int(hero.health).is_equal(0)
	assert_bool(hero.is_dead()).is_true()


func test_heal_stops_at_maximum() -> void:
	# Arrange
	var hero := _make_hero(AbilityScores.new())
	hero.take_damage(5)

	# Act
	hero.heal(100)

	# Assert
	assert_int(hero.health).is_equal(hero.max_health)
