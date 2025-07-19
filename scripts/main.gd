extends Node2D

@onready var world := $World as World

func _ready() -> void:
    GameState.world = world
    GameState.game_data = GameData.new()
