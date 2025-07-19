extends Node2D

@onready var world := $World as World

func _ready() -> void:
    GameState.world = world
    world.bubble_container.update()
