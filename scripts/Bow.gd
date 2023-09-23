@icon("res://sprites/player.png")

extends Node2D

class_name Player

const ProjectileScn := preload("res://assests/Projectile.tscn")
var arrows_left = true

signal arrow_fired


func _ready() -> void:
	connect("arrow_fired", Callable(get_tree().root.get_node("World"), "arrow_fired"))


func _physics_process(_delta: float) -> void:
	$Cannon.look_at(get_global_mouse_position())

	if Input.is_action_just_released("shoot"):
		fire(ProjectileScn)


func fire(projectile: PackedScene) -> void:
	if not arrows_left:
		return
	var arrow: Projectile = projectile.instantiate()
	get_tree().root.add_child(arrow)
	arrow.connect("balloon_hit", Callable(get_tree().root.get_node("World"), "balloon_hit"))
	arrow.start($Cannon.get_global_transform())
	emit_signal("arrow_fired")


func are_arrow_left(_arrows_left) -> void:
	arrows_left = _arrows_left
