@icon("res://sprites/balloon-icon.png")

class_name Target

extends Area2D

var speed = 10


class TargetType:
	var color: Color
	var speed: int

	func _init(_color: Color, _speed: int) -> void:
		self.color = _color
		self.speed = _speed

	func to_dict() -> Dictionary:
		return {color = color.to_html(), speed = speed}

	static func from_dict(dict: Dictionary) -> TargetType:
		return TargetType.new(Color(dict["color"]), dict["speed"])


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
