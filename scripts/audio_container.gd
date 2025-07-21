class_name AudioContainer extends Node

@export var sound : AudioStreamOggVorbis

var players : Array[AudioStreamPlayer] = []

var count : int
var index := 0

var _queue := 0


func _ready () -> void:
    for child: AudioStreamPlayer in get_children():
        child.volume_db = -10.0
        child.stream = sound
        players.append(child)
    
    count = players.size()


func _process(_delta: float) -> void:
    if _queue > 0:
        for n in 32:
            _play_from_queue()
            _queue -= 1
            if _queue == 0:
                break


func play_sound() -> void:
    _queue += 1


func _play_from_queue() -> void:
    players[index].pitch_scale = GameState.RNG.randf_range(0.8, 1.2)
    players[index].play()
    index = (index + 1) % count