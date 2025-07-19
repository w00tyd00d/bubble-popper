class_name World extends Node2D

# const BUBBLE_AREA := Rect2i(64, 64, 640 - 96, 360 - 96)

@onready var bubble_container := $BubbleContainer as BubbleContainer

@onready var bubble_area := $HUD/BubbleArea as ReferenceRect
@onready var cursor_area := $CursorArea as Area2D


func get_random_position() -> Vector2:
    var rx := GameState.RNG.randf_range(0, bubble_area.size.x)
    var ry := GameState.RNG.randf_range(0, bubble_area.size.y)
    return Vector2(rx, ry) + bubble_area.position