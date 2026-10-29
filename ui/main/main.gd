extends Control
## Starts a new run: character creation, then the first room.

const FIRST_ROOM: DialogueResource = preload("res://narrative/rooms/tollgate.dialogue")

var _streams: RngStreams

@onready var _map_label: Label = %MapLabel
@onready var _creation_screen: CreationScreen = %CreationScreen
@onready var _room_view: RoomView = %RoomView


func _ready() -> void:
	_streams = RngStreams.new(RngStreams.random_seed())
	_creation_screen.setup(_dice(RngStreams.Stream.CHARACTERS))
	_creation_screen.hero_created.connect(_on_hero_created)
	_room_view.finished.connect(_on_room_finished)
	_room_view.hide()
	_map_label.text = "Seed %d" % _streams.run_seed


func _on_hero_created(hero: Hero) -> void:
	var state := RoomState.new(hero, _dice(RngStreams.Stream.NARRATIVE))
	state.hero_changed.connect(_show_hero.bind(hero))
	_show_hero(hero)
	_creation_screen.hide()
	_room_view.show()
	_room_view.start(FIRST_ROOM, state)


func _on_room_finished() -> void:
	_room_view.add_choice("Start again", _restart)


func _show_hero(hero: Hero) -> void:
	_map_label.text = "%s\n\nSeed %d" % [hero.summary(), _streams.run_seed]


func _restart() -> void:
	get_tree().reload_current_scene()


func _dice(stream: RngStreams.Stream) -> Dice:
	return Dice.new(_streams.get_stream(stream))
