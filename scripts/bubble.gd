class_name Bubble extends Node2D

const RESPAWN_DURATION := 0.7
const MOVEMENT_SPEED := 1.5

# const RAINBOW_DIVISOR : float = 250
# const RAINBOW_CHANCE : Array[float] = [
#     1 / RAINBOW_DIVISOR,
#     2 / RAINBOW_DIVISOR,
#     4 / RAINBOW_DIVISOR,
#     8 / RAINBOW_DIVISOR,
#     16 / RAINBOW_DIVISOR,
#     32 / RAINBOW_DIVISOR
# ]

const RAINBOW_CHANCE := 2 / 250.0

var world : World :
    get: return GameState.world

var container : BubbleContainer :
    get: return get_parent().get_parent()

var time : int :
    get: return Time.get_ticks_msec()

var bubble_value : int :
    get: return 2 ** GameState.bubble_value_level

var explosion_resistant : bool :
    get: return time < _explosion_resist_timer

var is_rainbow : bool :
    get: return container.current_rainbow == self

var _anchor_position : Vector2
var _text_reset_position : Vector2

var _moving := false
var _move_direction := true
var _move_tween : Tween

var _explosion_resist_timer := 0 :
    set(num): _explosion_resist_timer = time + num

@onready var sprite := $Sprite2D as Sprite2D
@onready var area := $Area2D as Area2D
@onready var value_label := $Value as ShadowLabel
@onready var audio_player := $AudioStreamPlayer as AudioStreamPlayer


func _ready() -> void:
    area.mouse_entered.connect(func() -> void:
        if area.visible:
            collect(Bubble.rainbow_value() if is_rainbow else 1)
    )

    _anchor_position = position
    _text_reset_position = value_label.position


func _process(_delta: float) -> void:
    if area.shape.disabled or _moving: return

    drift()


static func rainbow_value() -> int:
    return 2 ** GameState.rainbow_bubble_level


func collect(mod := 1) -> void:
    if _move_tween and _move_tween.is_running():
        _move_tween.stop()

    _moving = true

    if container.current_rainbow == self:
        container.collect_rainbow()

    container.audio_container.play_sound()

    GameState.bubble_count += bubble_value * mod
    _animate_value(mod)

    area.disable()
    sprite.hide()
    await get_tree().create_timer(RESPAWN_DURATION).timeout
    appear()


func find_new_position() -> void:
    position = world.get_random_position()
    _anchor_position = position


func appear() -> void:
    if GameState.rainbow_bubble_level > 0 and _check_rainbow_chance():
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

    if not explosion_resistant:
        resist_explosion(500)


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


func resist_explosion(_time: int) -> void:
    _explosion_resist_timer = _time


func _check_rainbow_chance() -> bool:
    # var idx := GameState.rainbow_bubble_level
    # var chance := RAINBOW_CHANCE[idx]
    return GameState.RNG.randf() < RAINBOW_CHANCE


func _animate_value(mod: int) -> void:
    if mod > 1:
        value_label.material.set_shader_parameter("strength", 0.67)

    value_label.set_string("+{0}".format([bubble_value * mod]))
    value_label.show()

    var end_pos := _text_reset_position + Vector2(0, -16)
    var tween := create_tween()

    tween.tween_property(value_label, "position", end_pos, RESPAWN_DURATION)
    tween.parallel().tween_property(value_label, "modulate:a", 0, RESPAWN_DURATION)
    tween.tween_callback(func():
        value_label.hide()
        value_label.modulate.a = 1
        value_label.position = _text_reset_position
        value_label.material.set_shader_parameter("strength", 0.0)

    )
