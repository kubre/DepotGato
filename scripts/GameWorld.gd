class_name GameWorld

extends Node2D

# Constants
const BALLOON_SPAWN_Y = 290

# Variables
var score := 0
var level_data := GameData.levels[0]
var target_appeared_count := 0

# Nodes and Scenes
@onready var TargetScn := preload("res://assests/Target.tscn")
@onready var score_label := $HUD/ScoreBoard/ScoreLabel
@onready var game_over_board := $HUD/GameOverBoard
@onready var loser_timer := $LoseTimer

func _ready() -> void:
	score_label.text = str(score)
	$BalloonSpawnTimer.wait_time = level_data.spawn_time


# Game start
func set_game_level(level: int) -> void:
	level_data = GameData.levels[level]


func _on_Timer_timeout() -> void:
	spawn_target()


func spawn_target() -> void:
	var target_balloon = TargetScn.instantiate()
	target_balloon.set_type(level_data.target_types.pick_random())
	target_balloon.global_position = Vector2(level_data.lanes.pick_random(), BALLOON_SPAWN_Y)
	$".".add_child(target_balloon)

	target_appeared_count += 1
	if target_appeared_count == level_data.target_count:
		end_level()


func balloon_hit() -> void:
	score += 1
	score_label.text = str(score)


func end_level() -> void:
	GameData.game_state = GameData.GAME_STATE.FINISHED
	$BalloonSpawnTimer.stop()
	game_over_board.show()


# Release the balloon if it reaches the top
func _on_Destroy_area_entered(area: Area2D) -> void:
	area.queue_free()


func _on_PlayAgainButton_pressed() -> void:
	get_tree().reload_current_scene()
