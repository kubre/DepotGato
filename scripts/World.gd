extends Node2D


var Balloon:= preload("res://assests/Balloon.tscn")
export var colors := [ Color.darkgray ,Color.aqua, Color.red,
    Color.greenyellow, Color.yellow,  Color.antiquewhite,
    Color.violet, Color.darkorange, Color.olive]
var score := 0
export var num_arrows := 10
signal arrows_left(_arrows_left)

func _ready() -> void:
    $HUD/ScoreBoard/ScoreLabel.text = str(score)
    $HUD/ScoreBoard/ArrowsLabel.text = str(num_arrows)


func _on_Timer_timeout() -> void:
    var spawn_pos = $BalloonSpawner.global_position
    spawn_pos.x += rand_range(-20, 20)
    var balloon:= Balloon.instance()
    balloon.global_position = spawn_pos
    balloon.modulate = colors[randi() % colors.size()]
    $".".add_child(balloon)


func _on_Destroy_area_entered(area: Area2D) -> void:
    area.queue_free()


func balloon_hit()-> void:
    score += 1
    num_arrows += 1
    emit_signal("arrows_left", true)
    $HUD/ScoreBoard/ScoreLabel.text = str(score)
    $HUD/ScoreBoard/ArrowsLabel.text = str(num_arrows)


func arrow_fired()-> void:
    if num_arrows == 0:
        $LoseTimer.start()
        emit_signal("arrows_left", false)
    $HUD/ScoreBoard/ArrowsLabel.text = str(num_arrows)
    num_arrows -= 1


func _on_LoseTimer_timeout() -> void:
    $HUD/GameOverBoard.show()


func _on_PlayAgainButton_pressed() -> void:
    get_tree().reload_current_scene()
