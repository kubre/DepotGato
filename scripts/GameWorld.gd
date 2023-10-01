class_name GameWorld

extends Node2D

# Constants
const BALLOON_SPAWN_Y = 290

# Variables
var target_appeared_count := 0

var level_data: GameData.LevelMetadata

# Nodes and Scenes
@onready var TargetScn := preload("res://assests/Target.tscn")
@onready var MainMenuScn := preload("res://MainMenu.tscn")
@onready var score_label := $HUD/MarginContainer/ScoreBoard/ScoreLabel
@onready var level_progress_bar := $HUD/MarginContainer/ScoreBoard/ProgressBar
@onready var level_label := $HUD/LevelLabel
@onready var end_game_container := $"%EndGameContainer"
@onready var end_game_label := $"%EndGameBoardLabel"
@onready var end_game_button := $"%EndGameBoardButton"
@onready var infinite_level_progression_timer := $InfiniteLevelTimer


func _ready() -> void:
	set_game_data()
	reset_level_data()
	GameData.score_update.connect(score_update)
	GameData.end_level.connect(end_level)


func set_game_data() -> void:
	if GameData.current_level == GameData.INFINITE_LEVEL:
		# There is no end for infinite level so no need for progress bar
		level_progress_bar.hide()

		infinite_level_progression_timer.start()
		progress_infinite_level()
	else:
		level_data = GameData.levels[GameData.current_level]


func progress_infinite_level() -> void:
	if (
		GameData.infinite_level_progreession_tracker
		== GameData.infinite_progression_levels.size() - 1
	):
		infinite_level_progression_timer.stop()

	level_data = GameData.infinite_progression_levels[GameData.infinite_level_progreession_tracker]
	reset_spawn_rate()

	# Increase the spawn rate for the next level
	GameData.infinite_level_progreession_tracker += 1


func reset_level_data() -> void:
	GameData.score = 0
	score_label.text = str(GameData.score)
	level_label.text = "Level " + str(GameData.current_level + 1)
	level_progress_bar.value = 0

	GameData.game_state = GameData.GAME_STATE.PLAYING
	reset_spawn_rate()

	if GameData.current_level == GameData.INFINITE_LEVEL:
		GameData.infinite_level_progreession_tracker = 0


func reset_spawn_rate() -> void:
	$BalloonSpawnTimer.wait_time = level_data.spawn_time


func on_balloon_timer_timeout() -> void:
	spawn_target()

	var is_infinite_level := GameData.current_level == GameData.INFINITE_LEVEL
	if not is_infinite_level:
		check_for_level_end()
		update_level_progressbar()


func spawn_target() -> void:
	var target_balloon = TargetScn.instantiate()
	target_balloon.set_type(level_data.target_types.pick_random())
	target_balloon.global_position = Vector2(level_data.lanes.pick_random(), BALLOON_SPAWN_Y)
	$".".add_child(target_balloon)

	target_appeared_count += 1


func update_level_progressbar() -> void:
	level_progress_bar.value = (
		(target_appeared_count as float / level_data.target_count as float) * 100
	)


func score_update() -> void:
	score_label.text = str(GameData.score)


func check_for_level_end() -> void:
	var has_all_targets_spawned := target_appeared_count == level_data.target_count
	if has_all_targets_spawned:
		stop_balloon_spawner()


func stop_balloon_spawner() -> void:
	$BalloonSpawnTimer.stop()


func end_level():
	check_for_level_end()
	stop_balloon_spawner()
	end_game_container.show()

	match GameData.game_state:
		GameData.GAME_STATE.WIN:
			win_game()
		GameData.GAME_STATE.LOSE:
			lose_game()
		_:
			print("What? Future me, I only gave you two options!")


func win_game() -> void:
	end_game_label.text = "You've protected all of your Comrades!"
	var levels_count := GameData.levels.size()
	if GameData.current_level < levels_count - 1:
		end_game_button.text = "Next Level"
		end_game_button.pressed.connect(reload_level)
	else:
		end_game_label.text = "At last you won! No more cats being abducted!"
		end_game_button.text = "Main Menu"
		end_game_button.pressed.connect(back_to_main_menu)


func lose_game() -> void:
	end_game_label.text = "You've failed to protect your Comrades!"
	end_game_button.text = "Play Again?"
	end_game_button.pressed.connect(reload_level)


func reload_level() -> void:
	get_tree().reload_current_scene()


func back_to_main_menu() -> void:
	get_tree().change_scene_to_packed(MainMenuScn)


# Release the balloon if it reaches the top
func _on_Destroy_area_entered(area: Area2D) -> void:
	area.queue_free()


func on_target_reach_ship(area: Area2D) -> void:
	if area.is_in_group("Target") and GameData.game_state == GameData.GAME_STATE.PLAYING:
		GameData.game_state = GameData.GAME_STATE.LOSE
		GameData.end_level.emit()
