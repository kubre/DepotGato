@icon("res://sprites/balloon-icon.png")

class_name Target

extends Area2D

var speed = 50


class TargetType:
	var color: Color
	var speed: int

	func _init(color: Color, speed: int) -> void:
		self.color = color
		self.speed = speed


func set_type(target_type: TargetType) -> void:
	$AnimatedSprite2D.modulate = target_type.color
	speed = target_type.speed


func _physics_process(delta: float) -> void:
	position += gravity_direction.normalized() * speed * delta


func destroy():
	$AnimatedSprite2D.play("Burst")
	gravity_direction = -gravity_direction
	$CollisionShape2D.queue_free()
	$Timer.connect("timeout", queue_free)
	$Timer.start()
