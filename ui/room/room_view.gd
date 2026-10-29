class_name RoomView
extends VBoxContainer
## Plays a room's dialogue as a scrolling log with a list of choices.
##
## Lines without choices are shown straight away, so a whole passage
## appears at once, like a page of a gamebook.

signal finished

const START_CUE := "start"
const DEATH_CUE := "death"

var _resource: DialogueResource
var _state: RoomState
var _death_shown := false

@onready var _log_label: RichTextLabel = %LogLabel
@onready var _choice_list: VBoxContainer = %ChoiceList


## Clears the log and plays a room from its start cue.
func start(resource: DialogueResource, state: RoomState) -> void:
	_resource = resource
	_state = state
	_death_shown = false
	_log_label.clear()
	_state.check_resolved.connect(_on_check_resolved)
	_go_to(START_CUE)


## Adds a button to the list of choices.
func add_choice(text: String, action: Callable) -> void:
	var button := Button.new()
	button.text = text
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.pressed.connect(action)
	_choice_list.add_child(button)


func _go_to(cue: String) -> void:
	_clear_choices()
	var line := await _resource.get_next_dialogue_line(cue, [_state])
	if _state.hero.is_dead() and not _death_shown:
		_death_shown = true
		_go_to(DEATH_CUE)
	elif line == null:
		finished.emit()
	else:
		_show(line)


func _show(line: DialogueLine) -> void:
	_append(_format(line))
	if line.responses.is_empty():
		_go_to(line.next_id)
		return
	for response: DialogueResponse in line.responses:
		if response.is_allowed:
			add_choice(_choice_text(response), _choose.bind(response))


func _choose(response: DialogueResponse) -> void:
	_append("[i]> %s[/i]" % response.text)
	var spec := CheckSpec.from_tags(response.tags)
	if spec != null:
		_state.resolve(spec)
	_go_to(response.next_id)


func _choice_text(response: DialogueResponse) -> String:
	var spec := CheckSpec.from_tags(response.tags)
	if spec == null:
		return response.text
	return "%s (%s)" % [response.text, spec.label(_state.hero)]


func _format(line: DialogueLine) -> String:
	if line.character.is_empty():
		return line.text
	return "[b]%s:[/b] %s" % [line.character, line.text]


func _append(text: String) -> void:
	_log_label.append_text(text + "\n\n")


func _clear_choices() -> void:
	for child: Node in _choice_list.get_children():
		child.queue_free()


func _on_check_resolved(text: String) -> void:
	_append("[color=gray][i]%s[/i][/color]" % text)
