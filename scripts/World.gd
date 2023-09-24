extends Node2D

@onready var TargetScn := preload("res://assests/Target.tscn")
@onready var score_label := $HUD/ScoreBoard/ScoreLabel
@onready var arrow_label := $HUD/ScoreBoard/ArrowsLabel
@onready var game_over_board := $HUD/GameOverBoard
@onready var loser_timer := $LoseTimer

@export var num_arrows := 10

var score := 0
signal arrows_left(_arrows_left)

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


func _ready() -> void:
	score_label.text = str(score)
	arrow_label.text = str(num_arrows)


func _on_Timer_timeout() -> void:
	spawn_target()
	
	
func spawn_target() -> void:
	var target_type = TARGET_TYPES.pick_random()

	var target_balloon = TargetScn.instantiate()
	target_balloon.set_type(target_type)
	target_balloon.global_position = Vector2(FULL_LANE.pick_random(), 290)

	$".".add_child(target_balloon)



	
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
