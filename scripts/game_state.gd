extends Node

signal update_bubble_count(num: int)
signal update_shop_button(name: ShopButton.Id)

signal double_bubble_pressed
signal cursor_radius_pressed


enum Unlocks {
    DOUBLE_BUBBLE,
    CURSOR_RADIUS
}

var RNG := RandomNumberGenerator.new()

# Game Data

var total_count := 0
var bubble_count := 0 :
    set(num):
        var diff := num - bubble_count
        total_count += maxi(0, diff)
        bubble_count = num

        update_bubble_count.emit(bubble_count)
        _check_for_bubble_count_unlocks()

var cursor_radius_level := 0

var unlocked : Dictionary[Unlocks, bool] = {}
var world : World

#############

func unlock(_name: Unlocks) -> void:
    unlocked[_name] = true


func _check_for_bubble_count_unlocks() -> void:
    
    # Double Bubble
    if not unlocked.has(Unlocks.DOUBLE_BUBBLE) and bubble_count >= 50:
        update_shop_button.emit(ShopButton.Id.DOUBLE_BUBBLE)
        unlock(Unlocks.DOUBLE_BUBBLE)
    
    # Cursor Radius
    if not unlocked.has(Unlocks.CURSOR_RADIUS) and bubble_count >= 100:
        update_shop_button.emit(ShopButton.Id.CURSOR_RADIUS)
        unlock(Unlocks.CURSOR_RADIUS)