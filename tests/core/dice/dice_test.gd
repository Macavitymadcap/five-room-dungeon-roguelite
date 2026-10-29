extends GdUnitTestSuite
## Tests for Dice: ranges, coverage of every face, and determinism.

const SEED := 23
const ROLLS := 1000


func test_d5_stays_within_one_to_five() -> void:
	# Arrange
	var dice := _make_dice(SEED)

	# Act
	var results := _roll_d5s(dice, ROLLS)

	# Assert
	assert_bool(results.all(func(r: int) -> bool: return r >= 1 and r <= 5)).is_true()


func test_d5_rolls_every_face() -> void:
	# Arrange
	var dice := _make_dice(SEED)

	# Act
	var results := _roll_d5s(dice, ROLLS)

	# Assert
	assert_array(results).contains([1, 2, 3, 4, 5])


func test_roll_totals_stay_within_range() -> void:
	# Arrange
	var dice := _make_dice(SEED)

	# Act
	var totals: Array[int] = []
	for _i: int in range(ROLLS):
		totals.append(dice.roll(3))

	# Assert
	assert_bool(totals.all(func(t: int) -> bool: return t >= 3 and t <= 15)).is_true()


func test_roll_each_returns_one_result_per_die() -> void:
	# Arrange
	var dice := _make_dice(SEED)

	# Act
	var results := dice.roll_each(2)

	# Assert
	assert_array(results).has_size(2)


func test_same_seed_gives_same_rolls() -> void:
	# Arrange
	var first := _make_dice(SEED)
	var second := _make_dice(SEED)

	# Act
	var first_rolls := _roll_d5s(first, 20)
	var second_rolls := _roll_d5s(second, 20)

	# Assert
	assert_array(first_rolls).is_equal(second_rolls)


func _make_dice(seed_value: int) -> Dice:
	var streams := RngStreams.new(seed_value)
	return Dice.new(streams.get_stream(RngStreams.Stream.COMBAT))


func _roll_d5s(dice: Dice, count: int) -> Array[int]:
	var results: Array[int] = []
	for _i: int in range(count):
		results.append(dice.d5())
	return results
