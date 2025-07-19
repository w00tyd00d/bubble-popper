class_name Bubble extends Node2D

var world : World :
    get: return GameState.world

var game_data : GameData :
    get: return GameState.game_data


@onready var area := $Area2D as Area2D


func _ready() -> void:
    area.mouse_entered.connect(func() -> void:
        collect()
    )


func collect() -> void:
    game_data.bubble_count += 1

    hide()
    find_new_position()
    await get_tree().create_timer(0.2).timeout
    appear()


func find_new_position() -> void:
    position = world.get_random_position()


func appear() -> void:
    scale = Vector2()
    show()

    var tween := create_tween()
    tween.tween_property(self, "scale", Vector2(1,1), 0.3)