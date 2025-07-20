class_name Bubble extends Node2D

const RESPAWN_DURATION := 0.7
const MOVEMENT_SPEED := 1.5

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

var time : int :
    get: return Time.get_ticks_msec()

var bubble_value : int :
    get: return 2 ** GameState.bubble_value_level

var explosion_resistant := false

var _anchor_position : Vector2
var _text_reset_position : Vector2

var _moving := false
var _move_direction := true
var _move_tween : Tween

@onready var sprite := $Sprite2D as Sprite2D
@onready var area := $Area2D as Area2D
@onready var value_label := $Value as ShadowLabel


func _ready() -> void:
    area.mouse_entered.connect(func() -> void:
        collect()
    )

    _anchor_position = position
    _text_reset_position = value_label.position


func _process(_delta: float) -> void:
    if area.shape.disabled or _moving: return

    drift()

func collect() -> void:
    if _move_tween and _move_tween.is_running():
        _move_tween.kill()

    _moving = true

    if container.current_rainbow == self:
        container.collect_rainbow()

    GameState.bubble_count += bubble_value
    _animate_value()

    area.disable()
    sprite.hide()
    await get_tree().create_timer(RESPAWN_DURATION).timeout
    appear()


func find_new_position() -> void:
    position = world.get_random_position()
    _anchor_position = position


func appear() -> void:
    if _check_rainbow_chance():
        container.attempt_set_rainbow(self)

    find_new_position()

    scale = Vector2()
    sprite.show()
    show() # For new bubbles to spawn

    var tween := create_tween()
    tween.tween_property(self, "scale", Vector2(1,1), 0.3)
    tween.tween_callback(func():
        area.enable()
        _moving = false
    )


func drift() -> void:
    _moving = true

    var offset := Vector2(0, -4) if _move_direction else Vector2(0, 4)
    var dest := _anchor_position + offset

    _move_tween = create_tween()
    _move_tween.set_trans(Tween.TransitionType.TRANS_QUAD)
    _move_tween.set_ease(Tween.EaseType.EASE_IN_OUT)

    _move_tween.tween_property(self, "position", dest, MOVEMENT_SPEED)
    _move_tween.tween_interval(MOVEMENT_SPEED)
    _move_tween.tween_callback(func():
        _move_direction = not _move_direction
        _moving = false
    )


func set_rainbow(val: bool) -> void:
    var strength := 0.67 if val else 0.0
    sprite.material.set_shader_parameter("strength", strength)


func _check_rainbow_chance() -> bool:
    var idx := GameState.rainbow_chance_level
    var chance := RAINBOW_CHANCE[idx]
    return GameState.RNG.randf() < chance


func _animate_value() -> void:
    value_label.set_string("+{0}".format([bubble_value]))
    value_label.show()

    var end_pos := _text_reset_position + Vector2(0, -16)
    var tween := create_tween()

    tween.tween_property(value_label, "position", end_pos, RESPAWN_DURATION)
    tween.parallel().tween_property(value_label, "modulate:a", 0, RESPAWN_DURATION)
    tween.tween_callback(func():
        value_label.hide()
        value_label.modulate.a = 1
        value_label.position = _text_reset_position
    )
