class_name BubbleArea extends Area2D

@export var bubble : Bubble

@onready var shape := $CollisionShape2D as CollisionShape2D


func enable() -> void:
    shape.set_deferred("disabled", false)


func disable() -> void:
    shape.set_deferred("disabled", true)