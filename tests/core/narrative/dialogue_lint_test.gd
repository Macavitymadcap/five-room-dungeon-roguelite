extends GdUnitTestSuite
## Checks the raw text of every room file for authoring mistakes that
## Dialogue Manager accepts silently.

const ROOMS_DIR := "res://narrative/rooms"
## Everyone allowed to speak. Add new speakers here as rooms introduce them.
const SPEAKERS: Array[String] = ["Herald"]
const STRUCTURE_PREFIXES: Array[String] = [
	"~", "=>", "$>", "%", "if ", "elif ", "else", "while ", "match ",
	"when ", "#", "import ", "using ", "|"]


func test_every_room_file_is_indented_with_tabs() -> void:
	# Arrange
	var problems: Array[String] = []

	# Act
	for path: String in _room_files():
		var lines := _lines(path)
		for number: int in lines.size():
			if lines[number].begins_with(" "):
				problems.append("%s:%d" % [path, number + 1])

	# Assert
	assert_array(problems).is_empty()


func test_every_colon_names_a_known_speaker() -> void:
	# Arrange
	var problems: Array[String] = []

	# Act
	for path: String in _room_files():
		var lines := _lines(path)
		for number: int in lines.size():
			var speaker := _speaker(lines[number])
			if not speaker.is_empty() and not SPEAKERS.has(speaker):
				problems.append("%s:%d reads as speaker \"%s\"" % [path, number + 1, speaker])

	# Assert
	assert_array(problems).is_empty()


## The text before the first unescaped colon on a dialogue line or a
## response, or "" if there is none.
func _speaker(raw_line: String) -> String:
	var line := raw_line.strip_edges().trim_prefix("- ")
	if line.is_empty() or _is_structure(line):
		return ""
	var colon := line.find(":")
	while colon > 0 and line[colon - 1] == "\\":
		colon = line.find(":", colon + 1)
	return line.substr(0, colon) if colon > 0 else ""


func _is_structure(line: String) -> bool:
	return STRUCTURE_PREFIXES.any(func(prefix: String) -> bool: return line.begins_with(prefix))


func _room_files() -> Array[String]:
	var files: Array[String] = []
	for file: String in DirAccess.get_files_at(ROOMS_DIR):
		if file.ends_with(".dialogue"):
			files.append(ROOMS_DIR.path_join(file))
	return files


func _lines(path: String) -> PackedStringArray:
	return FileAccess.get_file_as_string(path).split("\n")
