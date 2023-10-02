@icon("res://sprites/player.png")

extends Node2D

class_name Player

const ProjectileScn := preload("res://assests/Projectile.tscn")
@onready var aim_point := $Cannon/AimPoint
@onready var reload_timer := $ReloadTimer
@onready var reload_progressbar := $ReloadProgress

var has_projectile := true


func _ready() -> void:
	if GameData.current_level == GameData.INFINITE_LEVEL:
		reload_timer.wait_time = 0.5

func _physics_process(_delta: float) -> void:
	# queue_redraw()
	$Cannon.look_at(get_global_mouse_position())
	reload_progressbar.value = 100 - (reload_timer.time_left / reload_timer.wait_time * 100)


func _input(event: InputEvent) -> void:
	var is_firing = event is InputEventMouseButton and event.is_action_pressed("shoot")
	var is_playing = GameData.game_state == GameData.GAME_STATE.PLAYING
	if is_firing and is_playing and has_projectile:
		fire()


func reload() -> void:
	has_projectile = true
	reload_timer.stop()


func fire() -> void:
	var arrow: Projectile = ProjectileScn.instantiate()
	get_tree().root.add_child(arrow)
	arrow.start($Cannon.get_global_transform())

	has_projectile = false
	reload_timer.start()
