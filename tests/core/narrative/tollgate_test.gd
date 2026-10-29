extends GdUnitTestSuite
## Plays the real Tollgate room through Dialogue Manager.

const TOLLGATE := "res://narrative/rooms/tollgate.dialogue"
const SEED := 23


func test_first_choice_has_a_check_for_every_ability() -> void:
	# Arrange
	var state := _make_state()

	# Act
	var line := await _first_choice(state)

	# Assert
	var abilities: Array[AbilityScores.Ability] = []
	for response: DialogueResponse in line.responses:
		var spec := CheckSpec.from_tags(response.tags)
		if spec != null and not abilities.has(spec.ability):
			abilities.append(spec.ability)
	assert_int(abilities.size()).is_equal(5)


func test_licence_option_is_only_for_fighters() -> void:
	# Arrange
	var state := _make_state()
	state.hero.character_class = CharacterClass.new()

	# Act
	var line := await _first_choice(state)

	# Assert
	assert_array(_texts(line)).not_contains(["Show your guild licence (Fighter)"])


func test_every_check_tag_is_valid() -> void:
	# Arrange
	var state := _make_state()

	# Act
	var line := await _first_choice(state)

	# Assert
	for response: DialogueResponse in line.responses:
		var has_tag := Array(response.tags).any(
				func(tag: String) -> bool: return tag.begins_with("check="))
		if has_tag:
			assert_object(CheckSpec.from_tags(response.tags)).is_not_null()


func test_a_failed_trap_hurts_the_hero() -> void:
	# Arrange
	var state := _make_state()
	var line := await _first_choice(state)
	var dash := _response(line, "Dash between the Herald's legs")
	state.passed = false
	var start_health := state.hero.health

	# Act
	var resource: DialogueResource = load(TOLLGATE)
	var next := await resource.get_next_dialogue_line(dash.next_id, [state])
	await resource.get_next_dialogue_line(next.next_id, [state])

	# Assert
	assert_int(state.hero.health).is_equal(start_health - 5)


func _first_choice(state: RoomState) -> DialogueLine:
	var resource: DialogueResource = load(TOLLGATE)
	var line := await resource.get_next_dialogue_line("start", [state])
	while line != null and line.responses.is_empty():
		line = await resource.get_next_dialogue_line(line.next_id, [state])
	return line


func _response(line: DialogueLine, text: String) -> DialogueResponse:
	for response: DialogueResponse in line.responses:
		if response.text == text:
			return response
	return null


func _texts(line: DialogueLine) -> Array[String]:
	var texts: Array[String] = []
	for response: DialogueResponse in line.responses:
		if response.is_allowed:
			texts.append(response.text)
	return texts


func _make_state() -> RoomState:
	var hero := Hero.create(
			load("res://data/species/human.tres") as Species,
			load("res://data/classes/fighter.tres") as CharacterClass,
			load("res://data/signs/bureaucracy.tres") as BirthSign,
			AbilityScores.new(), 8)
	var dice := Dice.new(RngStreams.new(SEED).get_stream(RngStreams.Stream.NARRATIVE))
	return RoomState.new(hero, dice)
