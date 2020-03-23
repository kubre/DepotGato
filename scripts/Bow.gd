extends Node2D


var arrow_spawn_point: Vector2
var Arrow := preload("res://assests/Arrow.tscn")
signal arrow_fired
var arrows_left = true

func _ready() -> void:
    connect("arrow_fired", get_tree().root.get_node("World"), "arrow_fired")

func _physics_process(delta: float) -> void:
    look_at(get_global_mouse_position())

    if Input.is_action_just_pressed("shoot"):
        $Sprite.frame = 1
    elif Input.is_action_just_released("shoot"):
        $Sprite.frame = 0
        fire(Arrow)

func fire(projectile)-> void:
    if not arrows_left:
            return
    var arrow = projectile.instance()
    get_tree().root.add_child(arrow)
    arrow.connect("balloon_hit", get_tree().root.get_node("World"), "balloon_hit")
    arrow.start(transform)
    emit_signal("arrow_fired")

func are_arrow_left(_arrows_left)-> void:
    arrows_left = _arrows_left
