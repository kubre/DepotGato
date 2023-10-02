extends Area2D

class_name Projectile

@export var speed := 50

var start_position := Vector2.ZERO
var velocity := Vector2.ZERO
var OFF_SCREEN := 1000

signal balloon_hit

func _ready() -> void:
	connect("balloon_hit", GameData.on_balloon_hit)


func start(_transform) -> void:
	global_transform = _transform
	velocity = transform.x * speed
	start_position = position


func _physics_process(_delta: float) -> void:
	rotation = velocity.angle()
	position += velocity

	if position.distance_to(start_position) > OFF_SCREEN:
		queue_free()


func _on_Arrow_area_entered(area: Area2D) -> void:
	if area.is_in_group("Target"):
		area.destroy()
		emit_signal("balloon_hit")
		queue_free()

