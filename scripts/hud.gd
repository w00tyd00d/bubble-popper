extends CanvasLayer

@onready var bubble_count := $BubblesCount as ShadowLabel

@onready var shop_buttons : Dictionary[ShopButton.Id, ShopButton] = {
    ShopButton.Id.DOUBLE_BUBBLE: %ShopButton1,
    ShopButton.Id.CURSOR_RADIUS: %ShopButton2
}

func _ready() -> void:

    GameState.update_shop_button.connect(func(id: ShopButton.Id) -> void:
        shop_buttons[id].update_level(1)
    )

    GameState.update_bubble_count.connect(func(num: int) -> void:
        var res := Util.stringify_int(num)
        bubble_count.set_string(res)
    )
