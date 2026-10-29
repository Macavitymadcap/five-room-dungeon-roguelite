class_name BirthSign
extends CreationChoice
## One of the five Discordian seasons a character can be born under.

@export_multiline var boon_text: String
@export_multiline var curse_text: String
## Added to this character's checks against traps.
@export var trap_check_bonus: int = 0
## Whether this character sees which choices lead into traps.
@export var labels_traps: bool = false
