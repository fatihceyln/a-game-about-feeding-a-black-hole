extends Area2D
class_name Asteroid

const BASE_COLOR: Color = Color(0.654, 0.397, 0.413, 1.0)
const FILL_COLOR: Color = Color(0.796, 0.490, 0.511, 1.0)
const POINT_COUNT_RANGE: Vector2i = Vector2i(7, 11)
const RADIUS_RATIO_RANGE: Vector2 = Vector2(0.85, 1.16)

const OUTLINE_COLOR: Color = Color(0.595, 0.352, 0.368, 1.0)
const OUTLINE_WIDTH: float = 3.0

const ORBIT_SPEED_RANGE: Vector2 = Vector2(0.3, 0.7)

const MAX_HEALTH: int = 3

@export var radius: float = 40.0

@onready var shape: Polygon2D = $Shape
@onready var fill_shape: Polygon2D = $FillShape
@onready var outline: Line2D = $Outline
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D

var health: int = MAX_HEALTH

# Orbit
var orbit_center: Vector2 = Vector2.ZERO
var orbit_radius: float = 0.0
var orbit_angle: float = 0.0
var orbit_speed: float = randf_range(ORBIT_SPEED_RANGE.x, ORBIT_SPEED_RANGE.y)

func _ready() -> void:
	var points: PackedVector2Array = make_polygon_points()
	shape.polygon = points
	shape.color = BASE_COLOR
	
	fill_shape.polygon = points
	fill_shape.color = FILL_COLOR
	
	outline.points = points
	outline.default_color = OUTLINE_COLOR
	outline.closed = true
	outline.width = OUTLINE_WIDTH

	collision_polygon.polygon = points


func _process(delta: float) -> void:
	orbit_angle += orbit_speed * delta
	position = orbit_center + (Vector2.from_angle(orbit_angle) * orbit_radius)


func setup_orbit(center: Vector2, distance: float, angle: float) -> void:
	orbit_center = center
	orbit_radius = distance
	orbit_angle = angle
	position = orbit_center + (Vector2.from_angle(orbit_angle) * orbit_radius)


func make_polygon_points() -> PackedVector2Array:
	var point_count: int = randi_range(POINT_COUNT_RANGE.x, POINT_COUNT_RANGE.y)
	var points: PackedVector2Array = PackedVector2Array()

	for i in point_count:
		var angle: float = TAU * float(i) / float(point_count)
		var radius_ratio: float = randf_range(RADIUS_RATIO_RANGE.x, RADIUS_RATIO_RANGE.y)
		var new_radius: float = radius * radius_ratio
		points.append(Vector2.RIGHT.rotated(angle) * new_radius)

	return points


func take_damage() -> void:
	health -= 1
	print("damage taken, current health: ", health)
	if health <= 0:
		queue_free()
