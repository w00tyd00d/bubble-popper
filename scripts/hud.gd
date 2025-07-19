extends CanvasLayer

@onready var bubble_count := $BubblesCount as Label
@onready var bubble_count_shadow := $BubblesCount/Shadow as Label


func _ready() -> void:

    GameState.update_bubble_count.connect(func(num: int) -> void:
        var res := Util.stringify_int(num)
        
        bubble_count.text = res
        bubble_count_shadow.text = res
    )
