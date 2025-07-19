extends TextureButton

@onready var display := $Display as Control


func _ready() -> void:
    button_down.connect(func() -> void:
        display.position = Vector2(4,4)
    )

    button_up.connect(func() -> void:
        display.position = Vector2()
    )
