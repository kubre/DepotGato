extends Node2D

@onready var TargetScn := preload("res://assests/Target.tscn")

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


func _ready() -> void:
	$HUD/ScoreBoard/ScoreLabel.text = str(score)
	$HUD/ScoreBoard/ArrowsLabel.text = str(num_arrows)


func _on_Timer_timeout() -> void:
	var spawn_pos = $BalloonSpawner.global_position
	spawn_pos.x += randf_range(-20, 20)

	var target_type = TARGET_TYPES.pick_random()

	var target_balloon = TargetScn.instantiate()
	target_balloon.set_type(target_type)
	target_balloon.global_position = spawn_pos

	$".".add_child(target_balloon)


func _on_Destroy_area_entered(area: Area2D) -> void:
	area.queue_free()


func balloon_hit() -> void:
	score += 1
	num_arrows += 1
	emit_signal("arrows_left", true)
	$HUD/ScoreBoard/ScoreLabel.text = str(score)
	$HUD/ScoreBoard/ArrowsLabel.text = str(num_arrows)


func arrow_fired() -> void:
	num_arrows -= 1
	if num_arrows == 0:
		$LoseTimer.start()
		emit_signal("arrows_left", false)
	$HUD/ScoreBoard/ArrowsLabel.text = str(num_arrows)


func _on_LoseTimer_timeout() -> void:
	$HUD/GameOverBoard.show()


func _on_PlayAgainButton_pressed() -> void:
	get_tree().reload_current_scene()
