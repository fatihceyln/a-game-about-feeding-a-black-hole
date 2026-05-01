extends Area2D
class_name Clicker

const RADIUS: float = 70.0
const SEGMENT_COUNT: int = 12
const SEGMENT_RATIO: float = 0.7
const SPEED: float = 0.6

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var angle_offset: float = 0.0
var speed_boost: float = 0.0

func _ready() -> void:
	var circle: CircleShape2D = collision_shape.shape as CircleShape2D
	circle.radius = RADIUS

func _process(delta: float) -> void:
	angle_offset = wrapf(angle_offset + (delta * (SPEED + speed_boost)), 0.0, TAU)
	queue_redraw()


func _draw() -> void:
	var segment_size: float = TAU / SEGMENT_COUNT

	for i: int in SEGMENT_COUNT:
		var start_angle: float = angle_offset + (float(i) * segment_size)
		var end_angle: float = start_angle + (segment_size * SEGMENT_RATIO)
		draw_arc(Vector2.ZERO, RADIUS, start_angle, end_angle, 20, Color.BLACK, 6)		


func play_hit_animation() -> void:
	var scale_tween: Tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	scale_tween.tween_property(self, "scale", Vector2.ONE, 0.1)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

	var speed_tween: Tween = create_tween()
	speed_tween.tween_property(self, "speed_boost", 2, 0.1)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	speed_tween.tween_property(self, "speed_boost", 0.0, 0.2)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
