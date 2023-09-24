extends Node2D

@onready var TargetScn := preload("res://assests/Target.tscn")
@onready var score_label := $HUD/ScoreBoard/ScoreLabel
@onready var arrow_label := $HUD/ScoreBoard/ArrowsLabel
@onready var game_over_board := $HUD/GameOverBoard
@onready var loser_timer := $LoseTimer

@export var num_arrows := 10

var score := 0
signal arrows_left(_arrows_left)

const BALLOON_SPAWN_Y = 290

@onready var level_data := LevelsData.levels[4]

var target_appeared := 0


func _ready() -> void:
	score_label.text = str(score)
	arrow_label.text = str(num_arrows)


func _on_Timer_timeout() -> void:
	spawn_target()


func spawn_target() -> void:
	var target_balloon = TargetScn.instantiate()
	target_balloon.set_type(level_data.target_types.pick_random())
	target_balloon.global_position = Vector2(level_data.lanes.pick_random(), BALLOON_SPAWN_Y)
	$".".add_child(target_balloon)

	target_appeared += 1
	if target_appeared == level_data.target_count:
		end_level()


func end_level() -> void:
	$BalloonSpawnTimer.stop()


func _on_Destroy_area_entered(area: Area2D) -> void:
	area.queue_free()


func balloon_hit() -> void:
	score += 1
	num_arrows += 1
	emit_signal("arrows_left", true)
	score_label.text = str(score)
	arrow_label.text = str(num_arrows)


func arrow_fired() -> void:
	num_arrows -= 1
	if num_arrows == 0:
		loser_timer.start()
		emit_signal("arrows_left", false)
	arrow_label.text = str(num_arrows)


func _on_LoseTimer_timeout() -> void:
	game_over_board.show()


func _on_PlayAgainButton_pressed() -> void:
	get_tree().reload_current_scene()
