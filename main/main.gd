extends Node2D
class_name Main

const ASTEROID: PackedScene = preload("uid://db1ixbef0ki6")

@export var asteroid_count: int = 35
@export var spawn_radius_range: Vector2 = Vector2(160, 600)

@onready var black_hole: BlackHole = $BlackHole
@onready var clicker: Clicker = $Clicker
@onready var clicker_timer: Timer = $ClickerTimer


func _ready() -> void:
	spawn_asteroids()
	clicker_timer.start()


func _process(delta: float) -> void:
	clicker.global_position = get_global_mouse_position()

func spawn_asteroids() -> void:
	for i: int in asteroid_count:
		var asteroid: Asteroid = ASTEROID.instantiate()
		var angle: float = TAU * float(i) / float(asteroid_count)
		var distance: float = randf_range(spawn_radius_range.x, spawn_radius_range.y)
		add_child(asteroid)
		asteroid.setup_orbit(black_hole.position, distance, angle)


func _on_clicker_timer_timeout() -> void:
	print("attack")
