class_name RngStreams
extends RefCounted
## Independent random streams for one run, all derived from the run seed.
##
## Each game system draws from its own stream, so changing how one
## system uses randomness cannot change the results of another. New
## streams must only be added to the end of the enum, never inserted,
## or every existing seed will produce different runs.

enum Stream { CHARACTERS, DUNGEON, ENCOUNTERS, COMBAT, LOOT, NARRATIVE }

var run_seed: int
var _streams: Array[RandomNumberGenerator] = []


func _init(seed_value: int) -> void:
	run_seed = seed_value
	var master := RandomNumberGenerator.new()
	master.seed = seed_value
	for _i: int in range(Stream.size()):
		_streams.append(_make_stream(master.randi()))


## Returns the generator for one stream.
func get_stream(stream: Stream) -> RandomNumberGenerator:
	return _streams[stream]


## Returns a fresh, unpredictable seed for starting a new run.
static func random_seed() -> int:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi()


func _make_stream(stream_seed: int) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	rng.seed = stream_seed
	return rng
