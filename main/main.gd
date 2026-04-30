extends Node2D
class_name Main

const ASTEROID = preload("uid://db1ixbef0ki6")

@export var asteroid_count: int = 35
@export var spawn_radius_range: Vector2 = Vector2(160, 600)

@onready var black_hole: BlackHole = $BlackHole

func _ready() -> void:
	spawn_asteroids()


func spawn_asteroids() -> void:
	for i in asteroid_count:
		var asteroid: Asteroid = ASTEROID.instantiate()
		var angle: float = TAU * float(i) / asteroid_count
		var distance: float = randf_range(spawn_radius_range.x, spawn_radius_range.y)
		asteroid.position = black_hole.position + (Vector2.from_angle(angle) * distance)
		add_child(asteroid)
