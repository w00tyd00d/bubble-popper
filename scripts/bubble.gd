class_name Bubble extends Node2D

const RAINBOW_DIVISOR : float = 250
const RAINBOW_CHANCE : Array[float] = [
    0.0,
    1 / RAINBOW_DIVISOR,
    2 / RAINBOW_DIVISOR,
    4 / RAINBOW_DIVISOR,
    8 / RAINBOW_DIVISOR,
    16 / RAINBOW_DIVISOR,
    32 / RAINBOW_DIVISOR
]

var world : World :
    get: return GameState.world

var container : BubbleContainer :
    get: return get_parent()

var explosion_resistant := false

@onready var sprite := $Sprite2D as Sprite2D
@onready var area := $Area2D as Area2D


func _ready() -> void:
    area.mouse_entered.connect(func() -> void:
        collect()
    )


func collect() -> void:
    if container.current_rainbow == self:
        container.collect_rainbow()

    GameState.bubble_count += 1

    area.disable()
    hide()
    await get_tree().create_timer(0.7).timeout
    appear()


func find_new_position() -> void:
    position = world.get_random_position()


func appear() -> void:
    if _check_rainbow_chance():
        container.attempt_set_rainbow(self)

    find_new_position()

    scale = Vector2()
    show()

    var tween := create_tween()
    tween.tween_property(self, "scale", Vector2(1,1), 0.3)
    tween.tween_callback(func(): area.enable())


func set_rainbow(val: bool) -> void:
    var strength := 0.67 if val else 0.0
    sprite.material.set_shader_parameter("strength", strength)


func _check_rainbow_chance() -> bool:
    var idx := GameState.rainbow_chance_level
    var chance := RAINBOW_CHANCE[idx]
    return GameState.RNG.randf() < chance
