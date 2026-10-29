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


func test_existing_streams_keep_their_sequences() -> void:
	# Arrange
	# Recorded on main before the NARRATIVE stream was added. If this fails,
	# a stream was inserted or reordered, and every old seed has changed.
	var expected: Array[int] = [3688321001, 1710136774, 3747700061, 1600984951, 4202888916]
	var streams := RngStreams.new(SEED)

	# Act
	var actual: Array[int] = []
	for stream: int in range(expected.size()):
		actual.append(streams.get_stream(stream as RngStreams.Stream).randi())

	# Assert
	assert_array(actual).is_equal(expected)
