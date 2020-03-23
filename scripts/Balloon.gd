extends Area2D

class_name Balloon, "res://sprites/balloon-icon.png"

func _physics_process(delta: float) -> void:
    position += gravity_vec * delta
#    position.x = lerp(position.x, position.x + round(rand_range(-5, 5)), 0.25)


func destroy():
    $AnimatedSprite.play("Burst")
    gravity_vec = -gravity_vec
    $CollisionShape2D.queue_free()
    $Timer.connect("timeout", self, "queue_free")
    $Timer.start()
