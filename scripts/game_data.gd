class_name GameData extends Resource

var bubble_count := 0 :
    set(num):
        bubble_count = num
        GameState.update_bubble_count.emit(bubble_count)
