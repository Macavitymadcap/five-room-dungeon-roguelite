extends GdUnitTestSuite
## Tests for AbilityScores: the modifier rule and rolling.

const SEED := 23

@warning_ignore("unused_parameter")
func test_modifier_for(score: int, expected: int, test_parameters := [
		[3, -3], [4, -3], [5, -2], [8, -1], [9, 0],
		[10, 0], [11, 1], [14, 2], [15, 3]]) -> void:
	# Arrange
	# The score and expected modifier come from test_parameters.

	# Act
	var actual := AbilityScores.modifier_for(score)

	# Assert
	assert_int(actual).is_equal(expected)


func test_modifier_uses_the_named_score() -> void:
	# Arrange
	var scores := AbilityScores.new()
	scores.wits = 15

	# Act
	var actual := scores.modifier(AbilityScores.Ability.WITS)

	# Assert
	assert_int(actual).is_equal(3)


func test_roll_gives_scores_from_three_to_fifteen() -> void:
	# Arrange
	var dice := _make_dice(SEED)

	# Act
	var scores := AbilityScores.roll(dice)

	# Assert
	assert_int(scores.hits).is_between(3, 15)
	assert_int(scores.blitz).is_between(3, 15)
	assert_int(scores.wits).is_between(3, 15)
	assert_int(scores.whizz).is_between(3, 15)
	assert_int(scores.rizz).is_between(3, 15)


func test_same_seed_rolls_same_scores() -> void:
	# Arrange
	var first_dice := _make_dice(SEED)
	var second_dice := _make_dice(SEED)

	# Act
	var first := AbilityScores.roll(first_dice)
	var second := AbilityScores.roll(second_dice)

	# Assert
	assert_int(first.hits).is_equal(second.hits)
	assert_int(first.rizz).is_equal(second.rizz)


func _make_dice(seed_value: int) -> Dice:
	var streams := RngStreams.new(seed_value)
	return Dice.new(streams.get_stream(RngStreams.Stream.CHARACTERS))

func test_set_score_changes_only_that_ability() -> void:
	# Arrange
	var scores := AbilityScores.new()

	# Act
	scores.set_score(AbilityScores.Ability.WHIZZ, 14)

	# Assert
	assert_int(scores.whizz).is_equal(14)
	assert_int(scores.wits).is_equal(AbilityScores.AVERAGE_SCORE)


func test_copy_is_independent_of_the_original() -> void:
	# Arrange
	var original := AbilityScores.new()
	original.rizz = 12

	# Act
	var copied := original.copy()
	copied.rizz = 4

	# Assert
	assert_int(original.rizz).is_equal(12)
	assert_int(copied.rizz).is_equal(4)


func test_display_name_is_capitalised() -> void:
	# Arrange
	var ability := AbilityScores.Ability.WHIZZ

	# Act
	var actual := AbilityScores.display_name(ability)

	# Assert
	assert_str(actual).is_equal("Whizz")
