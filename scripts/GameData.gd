extends Node

enum LANES { FIRST = 285, SECOND = 335, THIRD = 385, FOURTH = 435 }

const BEGINNER_LANE: Array[LANES] = [LANES.THIRD]
const INTERMEDIATE_LANE: Array[LANES] = [LANES.SECOND, LANES.THIRD]
const FULL_LANE: Array[LANES] = [LANES.FIRST, LANES.SECOND, LANES.THIRD, LANES.FOURTH]

var TARGET_TYPES: Array[Target.TargetType] = [
	Target.TargetType.new(Color("73cd7a"), 30),
	Target.TargetType.new(Color("fb4631"), 40),
	Target.TargetType.new(Color("c9a400"), 50),
	Target.TargetType.new(Color("2f2f2f"), 60),
	Target.TargetType.new(Color("ffffff"), 70),
]


class LevelMetadata:
	var lanes: Array[LANES]
	var spawn_time: float
	var target_count: int
	var target_types: Array[Target.TargetType]

	func _init(
		_lanes: Array[LANES],
		_spawn_time: float,
		_target_count: int,
		_target_types: Array[Target.TargetType],
	):
		self.lanes = _lanes
		self.spawn_time = _spawn_time
		self.target_count = _target_count
		self.target_types = _target_types

	func to_dict():
		var target_types_dicts: Array[Dictionary] = []
		for target_type in self.target_types:
			target_types_dicts.append(target_type.to_dict())

		return {
			lanes = lanes,
			spawn_time = spawn_time,
			target_count = target_count,
			target_types = target_types_dicts,
		}

	static func from_dict(dict: Dictionary):
		var target_types_objs: Array[Target.TargetType] = []
		for target_type_dict in dict["target_types"] as Array:
			target_types_objs.append(Target.TargetType.from_dict(target_type_dict))

		var _lanes: Array[LANES] = []
		for lane in dict["lanes"] as Array:
			_lanes.append(lane as LANES)
		return (
			LevelMetadata
			. new(
				_lanes,
				dict["spawn_time"] as float,
				dict["target_count"] as int,
				target_types_objs,
			)
		)


enum GAME_STATE {
	PLAYING,
	WIN,
	LOSE,
}

var game_state := GAME_STATE.PLAYING

var current_level := 0
var unlocked_level := 0
var score := 0
var levels: Array[LevelMetadata]

signal end_level
signal score_update


func _init() -> void:
	levels = [
		LevelMetadata.new(BEGINNER_LANE, 2, 5, [TARGET_TYPES[0]]),
		LevelMetadata.new(INTERMEDIATE_LANE, 2, 20, [TARGET_TYPES[0], TARGET_TYPES[1]]),
		LevelMetadata.new(FULL_LANE, 1.5, 20, TARGET_TYPES),
		LevelMetadata.new(FULL_LANE, 1.5, 20, TARGET_TYPES),
		LevelMetadata.new(FULL_LANE, 1.5, 50, TARGET_TYPES),
		LevelMetadata.new(FULL_LANE, 1, 60, TARGET_TYPES),
	]
	load_game()
	end_level.connect(save_game)


func on_balloon_hit():
	AudioManager.play_sound(AudioManager.AUDIO_EFFECTS["BALLOON_POP"])
	score += 1
	score_update.emit()

	if score == levels[current_level].target_count:
		game_state = GAME_STATE.WIN
		current_level += 1
		unlocked_level = max(unlocked_level, current_level)
		end_level.emit()


const SAVE_FILE_PATH = "user://save-data.json"


func load_game() -> void:
	var save_file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	if save_file == null:
		return

	var json := JSON.new()
	var parse_result := json.parse(save_file.get_as_text())
	if parse_result != OK:
		push_error("Error parsing save file")
		return

	var save_data := json.data as Dictionary

	unlocked_level = save_data["unlocked_level"] as int
	var _levels: Array = save_data["levels"]

	levels.clear()
	for level in _levels:
		levels.append(LevelMetadata.from_dict(level))


func save_game():
	var save_file := FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	print("Saving game", save_file.get_path_absolute())

	var levels_dicts: Array[Dictionary] = []
	for level in levels:
		levels_dicts.append(level.to_dict())

	var save_data := (
		JSON
		. stringify(
			{
				unlocked_level = unlocked_level,
				levels = levels_dicts,
			}
		)
	)
	save_file.store_string(save_data)
	save_file.close()
