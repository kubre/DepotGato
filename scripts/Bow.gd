@icon("res://sprites/player.png")

extends Node2D

class_name Player

const ProjectileScn := preload("res://assests/Projectile.tscn")
signal balloon_hit


func _physics_process(_delta: float) -> void:
	$Cannon.look_at(get_global_mouse_position())


func _input(event: InputEvent) -> void:
	var is_firing = event is InputEventMouseButton and event.is_pressed()
	var is_playing = GameData.game_state == GameData.GAME_STATE.PLAYING
	if is_firing and is_playing:
		fire(ProjectileScn)


func fire(projectile: PackedScene) -> void:
	var arrow: Projectile = projectile.instantiate()
	get_tree().root.add_child(arrow)
	arrow.connect("balloon_hit", Callable(get_tree().root.get_node("GameWorld"), "balloon_hit"))
	arrow.start($Cannon.get_global_transform())
