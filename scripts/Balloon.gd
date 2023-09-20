@icon("res://sprites/balloon-icon.png")

class_name Balloon

extends Area2D

func _physics_process(delta: float) -> void:
	position += gravity_direction * delta


func destroy():
	$AnimatedSprite2D.play("Burst")
	gravity_direction = -gravity_direction
	$CollisionShape2D.queue_free()
	$Timer.connect("timeout", Callable(self, "queue_free"))
	$Timer.start()
