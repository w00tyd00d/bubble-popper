@tool

class_name ShopButton extends TextureButton

enum Id {
    NONE,
    DOUBLE_BUBBLE,
    CURSOR_RADIUS,
}

@export var id: Id :
    set(_id):
        id = _id
        _assign_data()

@export var level := -1 :
    set(num):
        level = maxi(-1, num)
        if cost:
            var _cost := get_cost()
            cost.set_string("MAX" if _cost == -1 else str(_cost))

var label : String :
    set(string):
        label = string
        if label_name:
            label_name.set_string(string)

var texture : Texture2D :
    set(img):
        texture = img
        if icon:
            icon.texture = img

var costs : Array
var callback : Callable

var _data := ShopButtonData.new()

@onready var display := $Display as Control

@onready var label_name := %Name as ShadowLabel
@onready var cost := %Cost as ShadowLabel
@onready var icon := %Icon as TextureRect


func _ready() -> void:
    button_down.connect(func() -> void:
        display.position = Vector2(4,4)
        check_for_payment()
    )

    button_up.connect(func() -> void:
        display.position = Vector2()
    )

    label_name.set_string(label)
    icon.texture = texture


func get_cost() -> int:
    if level == -1 or level >= costs.size():
        return -1
    return costs[level]


func update_level(lvl_up := 0) -> void:
    show()
    level += lvl_up
    var _cost := get_cost()
    cost.set_string("MAX" if _cost == -1 else str(_cost))


func check_for_payment() -> void:
    var _cost := get_cost()
    if _cost == -1: return

    if GameState.bubble_count >= _cost:
        update_level(1)
        callback.call()
        GameState.bubble_count -= _cost


func _assign_data() -> void:
    var meta := _data.get_data(id)

    costs = meta.costs
    callback = meta.callback

    label = meta.label
    texture = meta.icon

    # label_name.set_string(meta["label"])
    # icon.texture = meta.icon

    if cost:
        update_level()
