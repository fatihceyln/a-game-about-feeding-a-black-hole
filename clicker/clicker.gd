extends Area2D
class_name Clicker

const RADIUS: float = 100.0
const SEGMENT_COUNT: int = 12
const SEGMENT_RATIO: float = 0.7

func _draw() -> void:
	var segment_size: float = TAU / SEGMENT_COUNT

	for i in SEGMENT_COUNT:
		var start_angle: float = float(i) * segment_size
		var end_angle: float = start_angle + (segment_size * SEGMENT_RATIO)
		draw_arc(Vector2.ZERO, RADIUS, start_angle, end_angle, 20, Color.BLACK, 8)		
