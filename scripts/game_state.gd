@tool

extends Node

signal update_bubble_count(num: int)
signal update_shop_button(name: ShopButton.Id)

signal check_afforability

signal explode_at(pos: Vector2)

signal double_bubble_pressed
signal cursor_radius_pressed
signal rainbow_bubble_pressed

var RNG := RandomNumberGenerator.new()

# Game Data

var total_count := 0
var bubble_count := 0 :
    set(num):
        var diff := num - bubble_count
        total_count += maxi(0, diff)
        bubble_count = num

        update_bubble_count.emit(bubble_count)
        check_afforability.emit()

        _check_for_bubble_count_unlocks()

var unlocked : Dictionary[ShopButton.Id, bool] = {}
var world : World

# Shop Upgrade Levels

var cursor_radius_level := 0
var rainbow_chance_level := 0

#############

func _ready() -> void:
    rainbow_bubble_pressed.connect(func():
        rainbow_chance_level += 1
    )


func unlock(id: ShopButton.Id) -> void:
    unlocked[id] = true


func _check_for_bubble_count_unlocks() -> void:
    _check_bubble_threshold(ShopButton.Id.DOUBLE_BUBBLE, 50)
    _check_bubble_threshold(ShopButton.Id.CURSOR_RADIUS, 100)
    _check_bubble_threshold(ShopButton.Id.RAINBOW_BUBBLE, 1000)


func _check_bubble_threshold(id: ShopButton.Id, amount: int) -> void:
    if not unlocked.has(id) and bubble_count >= amount:
        update_shop_button.emit(id)
        unlock(id)
