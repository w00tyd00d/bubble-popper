class_name BubbleContainer extends Node

var bubbles : Array[Node]
var bubble_count : int

var active := 4

func _ready() -> void:
    bubbles = get_children()
    bubble_count = bubbles.size()

    GameState.double_bubble_pressed.connect(double_capacity)


func update() -> void:
    for bubble: Bubble in bubbles:
        if not bubble.visible:
            break
        
        bubble.appear()
        await get_tree().process_frame
        


func double_capacity() -> void:
    if active == bubble_count: return
    
    for i in range(active, active * 2):
        var bubble := bubbles[i]
        bubble.appear()
        await get_tree().process_frame
    
    active *= 2