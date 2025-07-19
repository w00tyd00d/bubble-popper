extends Node

signal update_bubble_count(num: int)


var RNG := RandomNumberGenerator.new()

var game_data : GameData
var world : World