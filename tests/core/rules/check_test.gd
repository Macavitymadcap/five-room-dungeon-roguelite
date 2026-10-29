extends GdUnitTestSuite
## Tests for Check: the 2d5 roll and the named difficulties.

const SEED := 23


func test_roll_uses_two_dice() -> void:
	# Arrange
	var dice := Dice.new(RngStreams.new(SEED).get_stream(RngStreams.Stream.NARRATIVE))

	# Act
	var result := Check.roll(dice, 0, Check.MODERATE)

	# Assert
	assert_array(result.dice).has_size(2)


@warning_ignore("unused_parameter")
func test_target_for(difficulty: String, expected: int, test_parameters := [
		["easy", 6], ["moderate", 8], ["hard", 10]]) -> void:
	# Arrange
	# The difficulty and expected target come from test_parameters.

	# Act
	var actual := Check.target_for(difficulty)

	# Assert
	assert_int(actual).is_equal(expected)


func test_unknown_difficulty_is_rejected() -> void:
	# Arrange
	var difficulty := "impossible"

	# Act
	var known := Check.is_difficulty(difficulty)

	# Assert
	assert_bool(known).is_false()
