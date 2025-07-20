extends CanvasLayer

@onready var bubble_count := $BubblesCount as ShadowLabel

@onready var shop_buttons : Array[ShopButton] = [
    %ShopButton1,
    %ShopButton2,
    %ShopButton3,
    %ShopButton4,
    %ShopButton5,
    %ShopButton6,
    %ShopButton7,
]

func _ready() -> void:

    GameState.update_shop_button.connect(func(id: ShopButton.Id):
        for button in shop_buttons:
            if button.id == id:
                button.update_level(1)
                break
    )

    GameState.update_bubble_count.connect(func(num: int):
        var res := Util.stringify_int(num)
        bubble_count.set_string(res)
    )
