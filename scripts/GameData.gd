extends Node

var TARGET_TYPES: Array[Target.TargetType] = [
	Target.TargetType.new(Color("73cd7a"), 30),
	Target.TargetType.new(Color("fb4631"), 40),
	Target.TargetType.new(Color("c9a400"), 50),
	Target.TargetType.new(Color("2f2f2f"), 60),
	Target.TargetType.new(Color("ffffff"), 70),
]

enum LANES { FIRST = 285, SECOND = 335, THIRD = 385, FOURTH = 435 }

const BEGINNER_LANE: Array[LANES] = [LANES.THIRD]
const INTERMEDIATE_LANE: Array[LANES] = [LANES.SECOND, LANES.THIRD]
const FULL_LANE: Array[LANES] = [LANES.FIRST, LANES.SECOND, LANES.THIRD, LANES.FOURTH]


class LevelMetadata:
	var lanes: Array[LANES]
	var spawn_time: float
	var target_count: int
	var target_types: Array[Target.TargetType]

	func _init(
		_lanes: Array[LANES],
		_spawn_time: float,
		_target_count: int,
		_target_types: Array[Target.TargetType]
	):
		self.lanes = _lanes
		self.spawn_time = _spawn_time
		self.target_count = _target_count
		self.target_types = _target_types


var levels: Array[LevelMetadata] = [
	LevelMetadata.new(BEGINNER_LANE, 2, 5, [TARGET_TYPES[0]]),
	LevelMetadata.new(INTERMEDIATE_LANE, 2, 20, [TARGET_TYPES[0], TARGET_TYPES[1]]),
	LevelMetadata.new(FULL_LANE, 1.5, 20, TARGET_TYPES),
	LevelMetadata.new(FULL_LANE, 1.5, 20, TARGET_TYPES),
	LevelMetadata.new(FULL_LANE, 1.5, 50, TARGET_TYPES),
	LevelMetadata.new(FULL_LANE, 1, 60, TARGET_TYPES),
]

enum GAME_STATE {
	PLAYING,
	WIN,
	LOSE,
}

var game_state := GAME_STATE.PLAYING

var current_level := 0
var score := 0

signal end_level
signal score_update

func on_balloon_hit():
	score += 1
	emit_signal("score_update")

	if score == levels[current_level].target_count:
		game_state = GAME_STATE.WIN
		emit_signal("end_level")
