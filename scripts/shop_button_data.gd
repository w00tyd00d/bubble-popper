class_name ShopButtonData extends RefCounted


var _metadata := {
    ShopButton.Id.NONE: {
        "label": "Lorem\nIpsum",
        "icon": preload("uid://dvgyff4ya70lh"),
        "costs": [999999],

        "callback": (func():
        pass
        )
    },

    ShopButton.Id.DOUBLE_BUBBLE: {
        "label": "Double\nBubble",
        "icon": preload("uid://b862iwu6uxj50"),
        "costs": [50, 200, 1000, 5000, 25000, 150000, 500000],

        "callback": (func():
        GameState.double_bubble_pressed.emit()
        )
    },

    ShopButton.Id.BUBBLE_VALUE: {
        "label": "Bubble\nValue",
        "icon": preload("uid://dovs4o8dwvyk3"),
        "costs": [100, 400, 2000, 10000, 50000, 200000, 1000000, 5000000, 25000000, 100000000],

        "callback": (func():
        GameState.bubble_value_pressed.emit()
        )
    },

    ShopButton.Id.CURSOR_RADIUS: {
        "label": "Cursor\nRadius",
        "icon": preload("uid://bqh3l3xiv2lxj"),
        "costs": [150, 450, 2500, 12500],

        "callback": (func():
        GameState.cursor_radius_pressed.emit()
        )
    },

    ShopButton.Id.RAINBOW_BUBBLE: {
        "label": "Rainbow\nBubble",
        "icon": preload("uid://dg0yithqkl6x2"),
        "costs": [1000, 5000, 25000],

        "callback": (func():
        GameState.rainbow_bubble_pressed.emit()
        )
    },
}


func get_data(id: ShopButton.Id) -> Dictionary:
    return _metadata[id]
