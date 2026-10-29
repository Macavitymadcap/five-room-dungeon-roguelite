extends GdUnitTestSuite
## Tests for HeroBuilder: rolling, rerolls, the species bonus and building.

const SEED := 23


func test_roll_gives_glitz_from_six_to_ten() -> void:
	# Arrange
	var builder := _make_builder(SEED)

	# Act
	builder.roll()

	# Assert
	assert_int(builder.glitz).is_between(6, 10)


func test_reroll_costs_one_glitz() -> void:
	# Arrange
	var builder := _make_complete_builder(SEED, 0)
	builder.glitz = 8

	# Act
	var rerolled := builder.reroll(AbilityScores.Ability.WITS)

	# Assert
	assert_bool(rerolled).is_true()
	assert_int(builder.glitz).is_equal(7)


func test_reroll_changes_only_the_chosen_score() -> void:
	# Arrange
	var builder := _make_complete_builder(SEED, 0)
	builder.glitz = 8
	var original := builder.scores.copy()

	# Act
	builder.reroll(AbilityScores.Ability.WITS)

	# Assert
	assert_int(builder.scores.hits).is_equal(original.hits)
	assert_int(builder.scores.blitz).is_equal(original.blitz)
	assert_int(builder.scores.whizz).is_equal(original.whizz)
	assert_int(builder.scores.rizz).is_equal(original.rizz)


func test_reroll_refused_at_minimum_glitz() -> void:
	# Arrange
	var builder := _make_complete_builder(SEED, 0)
	builder.glitz = HeroBuilder.MIN_GLITZ

	# Act
	var rerolled := builder.reroll(AbilityScores.Ability.WITS)

	# Assert
	assert_bool(rerolled).is_false()
	assert_int(builder.glitz).is_equal(HeroBuilder.MIN_GLITZ)


func test_bonus_refused_without_species_bonus() -> void:
	# Arrange
	var builder := _make_complete_builder(SEED, 0)

	# Act
	var chosen := builder.choose_bonus(AbilityScores.Ability.WITS)

	# Assert
	assert_bool(chosen).is_false()


func test_bonus_refused_on_maximum_score() -> void:
	# Arrange
	var builder := _make_complete_builder(SEED, 1)
	builder.scores.wits = AbilityScores.MAX_SCORE

	# Act
	var chosen := builder.choose_bonus(AbilityScores.Ability.WITS)

	# Assert
	assert_bool(chosen).is_false()


func test_rerolling_the_bonus_ability_clears_the_bonus() -> void:
	# Arrange
	var builder := _make_complete_builder(SEED, 1)
	builder.glitz = 8
	builder.scores.wits = 10
	builder.choose_bonus(AbilityScores.Ability.WITS)

	# Act
	builder.reroll(AbilityScores.Ability.WITS)

	# Assert
	assert_bool(builder.is_complete()).is_false()


func test_build_refused_until_bonus_chosen() -> void:
	# Arrange
	var builder := _make_complete_builder(SEED, 1)

	# Act
	var hero := builder.build()

	# Assert
	assert_object(hero).is_null()


func test_build_applies_the_bonus() -> void:
	# Arrange
	var builder := _make_complete_builder(SEED, 1)
	builder.scores.wits = 10
	builder.choose_bonus(AbilityScores.Ability.WITS)

	# Act
	var hero := builder.build()

	# Assert
	assert_int(hero.scores.wits).is_equal(11)
	assert_int(builder.scores.wits).is_equal(10)


func test_same_seed_builds_same_hero() -> void:
	# Arrange
	var first := _make_complete_builder(SEED, 0)
	var second := _make_complete_builder(SEED, 0)

	# Act
	var first_hero := first.build()
	var second_hero := second.build()

	# Assert
	assert_int(first_hero.max_health).is_equal(second_hero.max_health)
	assert_int(first_hero.glitz).is_equal(second_hero.glitz)
	assert_int(first_hero.scores.rizz).is_equal(second_hero.scores.rizz)


func _make_builder(seed_value: int) -> HeroBuilder:
	var streams := RngStreams.new(seed_value)
	return HeroBuilder.new(Dice.new(streams.get_stream(RngStreams.Stream.CHARACTERS)))


func _make_complete_builder(seed_value: int, bonus: int) -> HeroBuilder:
	var builder := _make_builder(seed_value)
	var species := Species.new()
	species.ability_bonus = bonus
	builder.choose_species(species)
	builder.choose_class(CharacterClass.new())
	builder.choose_sign(BirthSign.new())
	builder.roll()
	return builder
