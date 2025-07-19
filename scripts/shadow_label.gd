@tool

class_name ShadowLabel extends Label

@onready var shadow := $Shadow as Label

func set_string(string: String) -> void:
    text = string
    shadow.text = string