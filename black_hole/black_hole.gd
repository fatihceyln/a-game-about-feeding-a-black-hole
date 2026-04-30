extends Node2D
class_name BlackHole

const RADIUS: float = 40.0
const COLOR: Color = Color(0.096, 0.096, 0.096, 1.0)

const RING_COUNT: int = 4
const RING_COLOR: Color = Color(0.12, 0.12, 0.12, 1.0)
const RING_SPEED: float = 1.2
const RING_ARC_RATIO: float = 0.6
const RING_SPEED_STEP: float = 0.2
const RING_RADIUS_BASE: float = RADIUS
const RING_RADIUS_STEP: float = 10.0

var passed_time: float = 0.0
var initial_angles: Dictionary[int, float] = {}


func _ready() -> void:
	for i in RING_COUNT:
		initial_angles[i] = randf_range(0, TAU)


func _process(delta: float) -> void:
	passed_time += delta
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, RADIUS, COLOR)

	for i in RING_COUNT:
		var color: Color = RING_COLOR
		color.a = 1.0 - (i * 0.2)
		var angle_offset: float = initial_angles[i]
		var start_angle: float = angle_offset + (passed_time * (RING_SPEED - (i * RING_SPEED_STEP)))
		var end_angle: float = start_angle + (TAU * RING_ARC_RATIO)
		draw_arc(Vector2.ZERO, RING_RADIUS_BASE + ((i + 1) * RING_RADIUS_STEP), start_angle, end_angle, 20, color, 3)
