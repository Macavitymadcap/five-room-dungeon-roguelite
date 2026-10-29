extends GdUnitTestSuite
## Tests for RoomState: checks, the trap bonus, damage and flags.

const SEED := 23


func test_resolve_records_whether_the_check_passed() -> void:
	# Arrange
	var state := _make_state(0)
	var spec := CheckSpec.create("wits", "moderate")

	# Act
	var result := state.resolve(spec)

	# Assert
	assert_bool(state.passed).is_equal(result.passed())


func test_resolve_adds_the_trap_bonus_to_traps() -> void:
	# Arrange
	var state := _make_state(2)
	state.hero.scores.blitz = 13
	var spec := CheckSpec.create("blitz", "moderate", true)

	# Act
	var result := state.resolve(spec)

	# Assert
	assert_int(result.modifier).is_equal(4)


func test_resolve_ignores_the_trap_bonus_elsewhere() -> void:
	# Arrange
	var state := _make_state(2)
	state.hero.scores.blitz = 13
	var spec := CheckSpec.create("blitz", "moderate")

	# Act
	var result := state.resolve(spec)

	# Assert
	assert_int(result.modifier).is_equal(2)


func test_resolve_emits_the_roll_text() -> void:
	# Arrange
	var state := _make_state(0)
	var spec := CheckSpec.create("rizz", "easy")
	var texts: Array[String] = []
	state.check_resolved.connect(func(text: String) -> void: texts.append(text))

	# Act
	state.resolve(spec)

	# Assert
	assert_str(texts[0]).starts_with("Rizz check: ")


func test_hurt_reduces_health() -> void:
	# Arrange
	var state := _make_state(0)
	var start := state.hero.health

	# Act
	state.hurt(3)

	# Assert
	assert_int(state.hero.health).is_equal(start - 3)


func test_flags_start_unset() -> void:
	# Arrange
	var state := _make_state(0)

	# Act
	state.flag("smash")

	# Assert
	assert_bool(state.flagged("smash")).is_true()
	assert_bool(state.flagged("dash")).is_false()


func test_has_class_matches_the_id() -> void:
	# Arrange
	var state := _make_state(0)
	state.hero.character_class.id = &"fighter"

	# Act
	var matches := state.has_class("fighter")

	# Assert
	assert_bool(matches).is_true()


func _make_state(trap_bonus: int) -> RoomState:
	var birth_sign := BirthSign.new()
	birth_sign.trap_check_bonus = trap_bonus
	var hero := Hero.create(Species.new(), CharacterClass.new(), birth_sign, AbilityScores.new(), 8)
	var dice := Dice.new(RngStreams.new(SEED).get_stream(RngStreams.Stream.NARRATIVE))
	return RoomState.new(hero, dice)
