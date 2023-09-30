class_name GameWorld

extends Node2D

# Constants
const BALLOON_SPAWN_Y = 290

# Variables
var target_appeared_count := 0

# Nodes and Scenes
@onready var TargetScn := preload("res://assests/Target.tscn")
@onready var MainMenuScn := preload("res://MainMenu.tscn")
@onready var score_label := $HUD/ScoreBoard/ScoreLabel
@onready var level_label := $HUD/ScoreBoard/LevelLabel
@onready var end_game_container := $"%EndGameContainer"
@onready var end_game_label := $"%EndGameBoardLabel"
@onready var end_game_button := $"%EndGameBoardButton"
@onready var level_data := GameData.levels[GameData.current_level]


func _ready() -> void:
	reset_level_data()
	GameData.score_update.connect(update_score)
	GameData.end_level.connect(end_level)


func reset_level_data():
	GameData.score = 0
	score_label.text = str(GameData.score)
	level_label.text = "Level " + str(GameData.current_level + 1)

	GameData.game_state = GameData.GAME_STATE.PLAYING

	$BalloonSpawnTimer.wait_time = level_data.spawn_time


func _on_Timer_timeout() -> void:
	spawn_target()


func spawn_target() -> void:
	var target_balloon = TargetScn.instantiate()
	target_balloon.set_type(level_data.target_types.pick_random())
	target_balloon.global_position = Vector2(level_data.lanes.pick_random(), BALLOON_SPAWN_Y)
	$".".add_child(target_balloon)

	target_appeared_count += 1
	if target_appeared_count == level_data.target_count:
		stop_spawing()


func stop_spawing() -> void:
	$BalloonSpawnTimer.stop()


func update_score() -> void:
	score_label.text = str(GameData.score)


func end_level():
	stop_spawing()
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
	if area.is_in_group("Target"):
		GameData.game_state = GameData.GAME_STATE.LOSE
		GameData.end_level.emit()
