class_name ScoreTable
extends GridContainer
## The five ability scores, with a reroll button and a bonus button each.

signal reroll_requested(ability: AbilityScores.Ability)
signal bonus_requested(ability: AbilityScores.Ability)

const HEADERS: Array[String] = ["Ability", "Score", "Modifier", "", ""]

var _score_labels: Array[Label] = []
var _modifier_labels: Array[Label] = []
var _reroll_buttons: Array[Button] = []
var _bonus_buttons: Array[Button] = []


func _ready() -> void:
	columns = HEADERS.size()
	for header: String in HEADERS:
		_add_label(header)
	for value: int in AbilityScores.Ability.values():
		_add_row(value as AbilityScores.Ability)


## Shows the builder's current scores and which buttons can be used.
func refresh(builder: HeroBuilder) -> void:
	var scores := builder.final_scores()
	for value: int in AbilityScores.Ability.values():
		var ability := value as AbilityScores.Ability
		_score_labels[value].text = str(scores.get_score(ability))
		_modifier_labels[value].text = "%+d" % scores.modifier(ability)
		_reroll_buttons[value].disabled = not builder.can_reroll()
		_bonus_buttons[value].visible = builder.offers_bonus()
		_bonus_buttons[value].disabled = not builder.can_choose_bonus(ability)


func _add_row(ability: AbilityScores.Ability) -> void:
	_add_label(AbilityScores.display_name(ability))
	_score_labels.append(_add_label(""))
	_modifier_labels.append(_add_label(""))
	_reroll_buttons.append(_add_button("Reroll (1 glitz)", reroll_requested, ability))
	_bonus_buttons.append(_add_button("+1", bonus_requested, ability))


func _add_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	add_child(label)
	return label


func _add_button(text: String, request: Signal, ability: AbilityScores.Ability) -> Button:
	var button := Button.new()
	button.text = text
	button.pressed.connect(func() -> void: request.emit(ability))
	add_child(button)
	return button
