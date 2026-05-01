extends Area2D
class_name Asteroid

const BASE_COLOR: Color = Color(0.654, 0.397, 0.413, 1.0)
const POINT_COUNT_RANGE: Vector2i = Vector2i(7, 11)
const RADIUS_RATIO_RANGE: Vector2 = Vector2(0.85, 1.15)

@export var radius: float = 40.0
@onready var shape: Polygon2D = $Shape

func _ready() -> void:
	shape.polygon = make_polygon_points()
	shape.color = BASE_COLOR

func make_polygon_points() -> PackedVector2Array:
	var point_count: int = randi_range(POINT_COUNT_RANGE.x, POINT_COUNT_RANGE.y)
	var points: PackedVector2Array = PackedVector2Array()
	
	for i: int in point_count:
		var angle: float = TAU * float(i) / float(point_count)
		var radius_ratio: float = randf_range(RADIUS_RATIO_RANGE.x, RADIUS_RATIO_RANGE.y)
		var new_radius: float = radius * radius_ratio
		points.append(Vector2.RIGHT.rotated(angle) * new_radius)
		
	return points
