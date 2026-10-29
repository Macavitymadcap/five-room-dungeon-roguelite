class_name Species
extends CreationChoice
## One of the five playable species.

@export_multiline var passive_text: String
## Points the player adds to one ability score of their choice. Human only.
@export_range(0, 1) var ability_bonus: int = 0
