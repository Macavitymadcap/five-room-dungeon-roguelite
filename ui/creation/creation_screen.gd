class_name CreationScreen
extends VBoxContainer
## Character creation: choose species, class and sign, then adjust scores.

signal hero_created(hero: Hero)

var _builder: HeroBuilder
var _species: Array[Species] = []
var _classes: Array[CharacterClass] = []
var _signs: Array[BirthSign] = []

@onready var _species_option: OptionButton = %SpeciesOption
@onready var _class_option: OptionButton = %ClassOption
@onready var _sign_option: OptionButton = %SignOption
@onready var _details_label: Label = %DetailsLabel
@onready var _score_table: ScoreTable = %ScoreTable
@onready var _summary_label: Label = %SummaryLabel
@onready var _begin_button: Button = %BeginButton


## Starts creation, rolling with dice from the run's CHARACTERS stream.
func setup(dice: Dice) -> void:
	_builder = HeroBuilder.new(dice)
	_load_choices()
	_builder.roll()
	_connect_signals()
	_refresh()


func _load_choices() -> void:
	_species = ContentLibrary.species()
	_classes = ContentLibrary.classes()
	_signs = ContentLibrary.signs()
	_fill(_species_option, _species)
	_fill(_class_option, _classes)
	_fill(_sign_option, _signs)
	_builder.choose_species(_species[0])
	_builder.choose_class(_classes[0])
	_builder.choose_sign(_signs[0])


func _fill(option: OptionButton, choices: Array) -> void:
	option.clear()
	for choice: CreationChoice in choices:
		option.add_item(choice.display_name)


func _connect_signals() -> void:
	_builder.changed.connect(_refresh)
	_species_option.item_selected.connect(_on_species_selected)
	_class_option.item_selected.connect(_on_class_selected)
	_sign_option.item_selected.connect(_on_sign_selected)
	_score_table.reroll_requested.connect(_builder.reroll)
	_score_table.bonus_requested.connect(_builder.choose_bonus)
	_begin_button.pressed.connect(_on_begin_pressed)


func _refresh() -> void:
	_details_label.text = _describe()
	_score_table.refresh(_builder)
	_summary_label.text = _summarise()
	_begin_button.disabled = not _builder.is_complete()


func _describe() -> String:
	return "%s\n\n%s\n\nBoon: %s\nCurse: %s" % [
		_builder.species.passive_text, _builder.character_class.description,
		_builder.birth_sign.boon_text, _builder.birth_sign.curse_text]


func _summarise() -> String:
	var scores := _builder.final_scores()
	return "Glitz %d   Health %d   Defence %d" % [
		_builder.glitz, Hero.health_for(scores), Hero.defence_for(scores)]


func _on_species_selected(index: int) -> void:
	_builder.choose_species(_species[index])


func _on_class_selected(index: int) -> void:
	_builder.choose_class(_classes[index])


func _on_sign_selected(index: int) -> void:
	_builder.choose_sign(_signs[index])


func _on_begin_pressed() -> void:
	hero_created.emit(_builder.build())
