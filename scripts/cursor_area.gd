class_name CursorArea extends Area2D

const SIZES : Array[int] = [0, 8, 16, 24, 32, 48, 64]

@onready var collision := $CollisionShape2D as CollisionShape2D


func _process(_delta: float) -> void:
    position = get_global_mouse_position()


func _ready() -> void:
    area_entered.connect(func(area: Area2D):
        if area is BubbleArea:
            var val := Bubble.rainbow_value() if area.bubble.is_rainbow else 1
            area.bubble.collect(val)
    )

    GameState.cursor_radius_pressed.connect(func():
        GameState.cursor_radius_level += 1
        collision.shape.radius = SIZES[GameState.cursor_radius_level]
    )
