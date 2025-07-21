extends Node2D

@onready var world := $World as World

# func _input(event: InputEvent) -> void:
#     if event.is_action_pressed(&"k_space"):
#         GameState.bubble_count += 100000


func _ready() -> void:
    GameState.world = world
    world.bubble_container.update()
