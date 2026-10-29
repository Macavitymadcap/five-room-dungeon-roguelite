extends GdUnitTestSuite
## Tests for CheckResult: totals, success at the target, and the roll text.


func test_total_adds_dice_and_modifier() -> void:
	# Arrange
	var result := CheckResult.new([3, 4], 1, 8)

	# Act
	var total := result.total()

	# Assert
	assert_int(total).is_equal(8)


func test_equalling_the_target_passes() -> void:
	# Arrange
	var result := CheckResult.new([3, 4], 1, 8)

	# Act
	var passed := result.passed()

	# Assert
	assert_bool(passed).is_true()


func test_margin_is_negative_on_a_failure() -> void:
	# Arrange
	var result := CheckResult.new([1, 2], 0, 8)

	# Act
	var margin := result.margin()

	# Assert
	assert_int(margin).is_equal(-5)


@warning_ignore("unused_parameter")
func test_describe(modifier: int, expected: String, test_parameters := [
		[1, "Wits check: 3 + 4 + 1 = 8 against 8, success"],
		[0, "Wits check: 3 + 4 = 7 against 8, failure"],
		[-2, "Wits check: 3 + 4 - 2 = 5 against 8, failure"]]) -> void:
	# Arrange
	var result := CheckResult.new([3, 4], modifier, 8)

	# Act
	var actual := result.describe("Wits check")

	# Assert
	assert_str(actual).is_equal(expected)
