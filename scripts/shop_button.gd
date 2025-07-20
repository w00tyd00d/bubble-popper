@tool

class_name ShopButton extends TextureButton

enum Id {
    NONE,
    DOUBLE_BUBBLE,
    CURSOR_RADIUS,
    RAINBOW_BUBBLE
}

static var button_data := ShopButtonData.new()

@export var id: Id :
    set(_id):
        id = _id
        _assign_data()

@export var level := -1 :
    set(num):
        level = maxi(-1, num)
        if cost_label:
            var _cost := get_cost()
            cost_label.set_string("MAX" if _cost == -1 else str(_cost))

var label : String :
    set(string):
        label = string
        if name_label:
            name_label.set_string(string)

var texture : Texture2D :
    set(img):
        texture = img
        if icon:
            icon.texture = img

var costs : Array
var callback : Callable

@onready var display := $Display as Control

@onready var name_label := %Name as ShadowLabel
@onready var cost_label := %Cost as ShadowLabel
@onready var icon := %Icon as TextureRect


func _ready() -> void:
    button_down.connect(func() -> void:
        display.position = Vector2(4,4)
        _check_for_payment()
    )

    button_up.connect(func() -> void:
        display.position = Vector2()
    )

    GameState.check_afforability.connect(func():
        _check_if_affordable()
    , ConnectFlags.CONNECT_DEFERRED)

    name_label.set_string(label)
    icon.texture = texture


func get_cost() -> int:
    if level == -1 or level >= costs.size():
        return -1
    return costs[level]


func update_level(lvl_up := 0) -> void:
    show()
    level += lvl_up
    var _cost := get_cost()
    cost_label.set_string("MAX" if _cost == -1 else str(_cost))


func _check_if_affordable() -> void:
    var _cost := get_cost()

    if _cost == -1:
        cost_label.modulate = Palette.GRAY

    elif _cost <= GameState.bubble_count:
        cost_label.modulate = Palette.WHITE

    else:
        cost_label.modulate = Palette.RED


func _check_for_payment() -> void:
    var _cost := get_cost()
    if _cost == -1: return

    if GameState.bubble_count >= _cost:
        update_level(1)
        callback.call()
        GameState.bubble_count -= _cost


func _assign_data() -> void:
    var meta := ShopButton.button_data.get_data(id)

    costs = meta.costs
    callback = meta.callback

    label = meta.label
    texture = meta.icon

    if cost_label:
        update_level()
