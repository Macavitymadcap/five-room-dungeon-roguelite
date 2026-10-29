extends GdUnitTestSuite
## Tests for RngStreams: determinism and independence of streams.

const SEED := 23


func test_same_seed_gives_same_sequence() -> void:
	# Arrange
	var first := RngStreams.new(SEED)
	var second := RngStreams.new(SEED)

	# Act
	var first_draws := _draw(first, RngStreams.Stream.COMBAT, 10)
	var second_draws := _draw(second, RngStreams.Stream.COMBAT, 10)

	# Assert
	assert_array(first_draws).is_equal(second_draws)


func test_different_seeds_give_different_sequences() -> void:
	# Arrange
	var first := RngStreams.new(SEED)
	var second := RngStreams.new(SEED + 1)

	# Act
	var first_draws := _draw(first, RngStreams.Stream.COMBAT, 10)
	var second_draws := _draw(second, RngStreams.Stream.COMBAT, 10)

	# Assert
	assert_array(first_draws).is_not_equal(second_draws)


func test_streams_are_independent() -> void:
	# Arrange
	var untouched := RngStreams.new(SEED)
	var disturbed := RngStreams.new(SEED)
	_draw(disturbed, RngStreams.Stream.COMBAT, 100)

	# Act
	var expected := _draw(untouched, RngStreams.Stream.DUNGEON, 10)
	var actual := _draw(disturbed, RngStreams.Stream.DUNGEON, 10)

	# Assert
	assert_array(actual).is_equal(expected)


func _draw(streams: RngStreams, stream: RngStreams.Stream, count: int) -> Array[int]:
	var rng := streams.get_stream(stream)
	var draws: Array[int] = []
	for _i: int in range(count):
		draws.append(rng.randi())
	return draws
