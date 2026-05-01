extends Area2D
class_name Asteroid

const BASE_COLOR: Color = Color(0.654, 0.397, 0.413, 1.0)
const POINT_COUNT_RANGE: Vector2i = Vector2i(7, 11)
const RADIUS_RATIO_RANGE: Vector2 = Vector2(0.85, 1.15)

const OUTLINE_COLOR: Color = Color(0.595, 0.352, 0.368, 1.0)
const OUTLINE_WIDTH: float = 3

@export var radius: float = 40.0
@onready var shape: Polygon2D = $Shape
@onready var outline: Line2D = $Outline

func _ready() -> void:
	var points: PackedVector2Array = make_polygon_points()
	shape.polygon = points
	shape.color = BASE_COLOR
	
	outline.points = points
	outline.default_color = OUTLINE_COLOR
	outline.closed = true
	outline.width = OUTLINE_WIDTH

func make_polygon_points() -> PackedVector2Array:
	var point_count: int = randi_range(POINT_COUNT_RANGE.x, POINT_COUNT_RANGE.y)
	var points: PackedVector2Array = PackedVector2Array()
	
	for i: int in point_count:
		var angle: float = TAU * float(i) / float(point_count)
		var radius_ratio: float = randf_range(RADIUS_RATIO_RANGE.x, RADIUS_RATIO_RANGE.y)
		var new_radius: float = radius * radius_ratio
		points.append(Vector2.RIGHT.rotated(angle) * new_radius)
		
	return points
