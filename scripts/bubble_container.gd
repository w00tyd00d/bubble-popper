class_name BubbleContainer extends Node

const RAINBOW_COOLDOWN := 5 * 1000

var bubbles : Array[Node]
var bubble_count : int

var current_rainbow : Bubble :
    set(bubble):
        if current_rainbow:
            current_rainbow.set_rainbow(false)

        current_rainbow = bubble

        if bubble:
            bubble.set_rainbow(true)


var rainbow_cd_time := 0

var active := 4

func _ready() -> void:
    bubbles = get_children()
    bubble_count = bubbles.size()

    GameState.double_bubble_pressed.connect(double_capacity)


func update() -> void:
    for bubble: Bubble in bubbles:
        if not bubble.visible:
            break

        bubble.appear()
        await get_tree().process_frame



func double_capacity() -> void:
    if active == bubble_count: return

    for i in range(active, active * 2):
        var bubble := bubbles[i]
        bubble.appear()
        await get_tree().process_frame

    active *= 2


func attempt_set_rainbow(bubble: Bubble) -> void:
    if current_rainbow or Time.get_ticks_msec() < rainbow_cd_time:
        return

    current_rainbow = bubble


func collect_rainbow() -> void:
    if not current_rainbow: return

    GameState.explode_at.emit(current_rainbow.position)
    current_rainbow = null
    rainbow_cd_time = Time.get_ticks_msec() + RAINBOW_COOLDOWN
