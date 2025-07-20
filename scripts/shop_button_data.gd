class_name ShopButtonData extends RefCounted


var _metadata := {
    ShopButton.Id.NONE: {
        "label": "Lorem\nIpsum",
        "icon": preload("uid://c1r18vxx4ng8s"),
        "costs": [999999],

        "callback": (func():
        pass
        )
    },

    ShopButton.Id.DOUBLE_BUBBLE: {
        "label": "Double\nBubble",
        "icon": preload("uid://b862iwu6uxj50"),
        # "costs": [50, 500, 5000],
        "costs": [0, 0, 0, 0, 0, 0, 0, 0],

        "callback": (func():
        GameState.double_bubble_pressed.emit()
        )
    },

    ShopButton.Id.CURSOR_RADIUS: {
        "label": "Cursor\nRadius",
        "icon": preload("uid://bqh3l3xiv2lxj"),
        "costs": [100, 2000, 40000],

        "callback": (func():
        GameState.cursor_radius_pressed.emit()
        )
    },

    ShopButton.Id.BUBBLE_VALUE: {
        "label": "Bubble\nValue",
        "icon": preload("uid://dovs4o8dwvyk3"),
        "costs": [250, 500, 2000, 10000],

        "callback": (func():
        GameState.bubble_value_pressed.emit()
        )
    },

    ShopButton.Id.RAINBOW_BUBBLE: {
        "label": "Rainbow\nBubble",
        "icon": preload("uid://dg0yithqkl6x2"),
        "costs": [1000, 10000],

        "callback": (func():
        GameState.rainbow_bubble_pressed.emit()
        )
    },
}


func get_data(id: ShopButton.Id) -> Dictionary:
    return _metadata[id]
