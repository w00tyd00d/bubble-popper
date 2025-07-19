class_name Bubble extends Node2D

var world : World :
    get: return GameState.world


@onready var area := $Area2D as Area2D


func collect() -> void:
    GameState.bubble_count += 1

    area.disable()
    hide()
    await get_tree().create_timer(0.2).timeout
    appear()


func find_new_position() -> void:
    position = world.get_random_position()


func appear() -> void:
    find_new_position()

    scale = Vector2()
    show()

    var tween := create_tween()
    tween.tween_property(self, "scale", Vector2(1,1), 0.3)
    tween.tween_callback(func(): area.enable())
