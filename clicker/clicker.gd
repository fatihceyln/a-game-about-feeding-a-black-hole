extends Area2D
class_name Clicker

const RADIUS: float = 100.0
const SEGMENT_COUNT: int = 12
const SEGMENT_ARC_RATIO: float = 0.7

func _draw() -> void:
	var segment_size: float = TAU / float(SEGMENT_COUNT)
	for i: int in SEGMENT_COUNT:
		var start_angle: float = float(i) * segment_size
		var end_angle: float = start_angle + (segment_size * SEGMENT_ARC_RATIO)
		draw_arc(Vector2.ZERO, RADIUS, start_angle, end_angle, 20, Color.BLACK, 8)
