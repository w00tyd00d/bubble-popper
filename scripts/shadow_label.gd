@tool

class_name ShadowLabel extends Label

@onready var shadow := $Shadow as Label

func _ready() -> void:
    modulate = Palette.WHITE


func set_string(string: String) -> void:
    text = string
    shadow.text = string
