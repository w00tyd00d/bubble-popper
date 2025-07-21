class_name ImpactLayer extends CanvasLayer


const DURATION := 1.25

var impact_size := 0.0 :
    set(num):
        impact_size = num
        shockwave.material.set_shader_parameter("size", num)

var explode_tween : Tween

@onready var shockwave := $Shockwave as ColorRect

@onready var damage_area := $DamageArea as Area2D
@onready var damage_collision := $DamageArea/CollisionShape2D as CollisionShape2D

@onready var safe_area := $SafeArea as Area2D
@onready var safe_collision := $SafeArea/CollisionShape2D as CollisionShape2D


# func _input(event: InputEvent) -> void:
#     if event.is_action_pressed(&"k_right_click"):
#         var pos := GameState.world.get_global_mouse_position()
#         explode_at(pos)


func _ready() -> void:
    damage_area.area_entered.connect(func(area: Area2D):
        if area.visible and area is BubbleArea and not area.bubble.explosion_resistant:
            area.bubble.resist_explosion(1250)
            area.bubble.collect(Bubble.rainbow_value())
    )

    # damage_area.area_exited.connect(func(area: Area2D):
    #     if area is BubbleArea and not area.bubble.explosion_resistant:
    #         area.bubble.explosion_resistant = false
    # )

    safe_area.area_entered.connect(func(area: Area2D):
        if area is BubbleArea:
            area.bubble.resist_explosion(1250)
    )

    # safe_area.area_exited.connect(func(area: Area2D):
    #     if area is BubbleArea:
    #         area.bubble.explosion_resistant = false
    # )

    GameState.explode_at.connect(explode_at)


func explode_at(pos: Vector2) -> void:
    if explode_tween and explode_tween.is_running(): return

    shockwave.material.set_shader_parameter("global_position", pos)
    damage_area.position = pos
    safe_area.position = pos

    explode_tween = create_tween()
    explode_tween.tween_property(self, "impact_size", 1.85, DURATION)
    explode_tween.parallel().tween_property(damage_collision.shape, "radius", 640, DURATION)
    explode_tween.tween_callback(func():
        impact_size = 0.0
        damage_collision.shape.radius = 0.01
        damage_area.position = Vector2()
    )

    await get_tree().create_timer(0.1).timeout
    var mult := 1.5

    var safe_tween := create_tween()
    safe_tween.tween_property(safe_collision.shape, "radius", 640 * mult, DURATION * mult)
    safe_tween.tween_callback(func():
        safe_collision.shape.radius = 0.01
        safe_area.position = Vector2()
    )
