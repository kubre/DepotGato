@icon("res://sprites/player.png")

extends Node2D

class_name Player

const ProjectileScn := preload("res://assests/Projectile.tscn")
signal balloon_hit


func _physics_process(_delta: float) -> void:
	$Cannon.look_at(get_global_mouse_position())

	if Input.is_action_just_released("shoot"):
		fire(ProjectileScn)


func fire(projectile: PackedScene) -> void:
	var arrow: Projectile = projectile.instantiate()
	get_tree().root.add_child(arrow)
	arrow.connect("balloon_hit", Callable(get_tree().root.get_node("GameWorld"), "balloon_hit"))
	arrow.start($Cannon.get_global_transform())
