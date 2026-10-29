extends Control
## Starts a new run and shows character creation.

@onready var _map_label: Label = %MapLabel
@onready var _creation_screen: CreationScreen = %CreationScreen


func _ready() -> void:
	var streams := RngStreams.new(RngStreams.random_seed())
	var dice := Dice.new(streams.get_stream(RngStreams.Stream.CHARACTERS))
	_creation_screen.setup(dice)
	_creation_screen.hero_created.connect(_on_hero_created)
	_map_label.text = "Seed %d" % streams.run_seed


func _on_hero_created(hero: Hero) -> void:
	_creation_screen.hide()
	_map_label.text = hero.summary()
