extends Area2D
class_name Asteroid

signal destroyed

const ASTEROID_DESTROY_PARTICLE: PackedScene = preload("uid://b0d4hv0um08bf")

const BASE_COLOR: Color = Color(0.654, 0.397, 0.413, 1.0)
const FILL_COLOR: Color = Color(0.796, 0.490, 0.511, 1.0)
const POINT_COUNT_RANGE: Vector2i = Vector2i(7, 11)
const RADIUS_RATIO_RANGE: Vector2 = Vector2(0.85, 1.15)

const OUTLINE_COLOR: Color = Color(0.595, 0.352, 0.368, 1.0)
const OUTLINE_WIDTH: float = 3

const ORBIT_SPEED_RANGE: Vector2 = Vector2(0.3, 0.7)
const ROTATION_SPEED_RANGE: Vector2 = Vector2(0.5, 1.5)

const MAX_HEALTH: int = 3

@export var radius: float = 40.0
@onready var shape: Polygon2D = $Shape
@onready var fill_shape: Polygon2D = $FillShape
@onready var outline: Line2D = $Outline
@onready var collision_polygon: CollisionPolygon2D = $CollisionPolygon2D

var health: int = MAX_HEALTH

var orbit_center: Vector2 = Vector2.ZERO
var orbit_radius: float = 0
var orbit_angle: float = 0
var orbit_speed: float = randf_range(ORBIT_SPEED_RANGE.x, ORBIT_SPEED_RANGE.y)

var fill_material: ShaderMaterial
var min_y: float = 0
var max_y: float = 0

var rotation_speed: float = randf_range(ROTATION_SPEED_RANGE.x, ROTATION_SPEED_RANGE.y)
var is_destroyed: bool = false
var fall_speed: float = 600
var orbit_acceleration: float = 2


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

	update_min_max_y()
	fill_material = fill_shape.material as ShaderMaterial
	fill_material.set_shader_parameter("min_y", min_y)
	fill_material.set_shader_parameter("max_y", max_y)
	fill_material.set_shader_parameter("progress", 0.0)


func _process(delta: float) -> void:
	if is_destroyed:
		orbit_angle += (orbit_speed + orbit_acceleration) * delta
		orbit_radius = maxf(orbit_radius - (fall_speed * delta), 0)
		fall_speed += fall_speed * delta

		scale = scale.move_toward(Vector2.ZERO, 0.5 * delta)

		if position.is_equal_approx(orbit_center):
			queue_free()
	else:
		orbit_angle += orbit_speed * delta
		
	position = orbit_center + Vector2.RIGHT.rotated(orbit_angle) * orbit_radius
	rotation = wrapf(rotation + (delta * rotation_speed), 0, TAU)


func make_polygon_points() -> PackedVector2Array:
	var point_count: int = randi_range(POINT_COUNT_RANGE.x, POINT_COUNT_RANGE.y)
	var points: PackedVector2Array = PackedVector2Array()
	
	for i: int in point_count:
		var angle: float = TAU * float(i) / float(point_count)
		var radius_ratio: float = randf_range(RADIUS_RATIO_RANGE.x, RADIUS_RATIO_RANGE.y)
		var new_radius: float = radius * radius_ratio
		points.append(Vector2.RIGHT.rotated(angle) * new_radius)
		
	return points


func setup_orbit(center: Vector2, distance: float, angle: float) -> void:
	orbit_center = center
	orbit_radius = distance
	orbit_angle = angle
	position = orbit_center + Vector2.RIGHT.rotated(orbit_angle) * orbit_radius


func take_damage() -> void:
	health -= 1
	fill_material.set_shader_parameter("progress", 1 - (float(health) / float(MAX_HEALTH)))
	if health <= 0:
		destroyed.emit()
		is_destroyed = true
		play_asteroid_destroy_particles()
		
		
	else:
		play_hit_animation()


func update_min_max_y() -> void:
	min_y = shape.polygon[0].y
	max_y = shape.polygon[0].y

	for point: Vector2 in shape.polygon:
		if point.y < min_y:
			min_y = point.y
		if point.y > max_y:
			max_y = point.y


func play_hit_animation() -> void:
	var current_rotation: float = rotation
	var new_rotation: float = current_rotation + randf_range(deg_to_rad(15), deg_to_rad(60))
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "rotation", new_rotation, 0.1)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2(1.35, 1.35), 0.1)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(0.1)
	tween.tween_property(self, "rotation", current_rotation, 0.1)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(0.1)


func play_asteroid_destroy_particles() -> void:
	var asteroid_destroy_particle: GPUParticles2D = ASTEROID_DESTROY_PARTICLE.instantiate() as GPUParticles2D
	asteroid_destroy_particle.modulate = FILL_COLOR
	get_parent().add_child(asteroid_destroy_particle)
	asteroid_destroy_particle.global_position = global_position
	asteroid_destroy_particle.emitting = true
	asteroid_destroy_particle.finished.connect(asteroid_destroy_particle.queue_free)
