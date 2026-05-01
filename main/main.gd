extends Node2D
class_name Main

const ASTEROID: PackedScene = preload("uid://db1ixbef0ki6")

@export var asteroid_count: int = 35
@export var spawn_radius_range: Vector2 = Vector2(160, 600)

@onready var black_hole: BlackHole = $BlackHole
@onready var clicker: Clicker = $Clicker
@onready var clicker_timer: Timer = $ClickerTimer
@onready var start_screen: Control = %StartScreen


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
	clicker.play_hit_animation()
	
	var overlapping_areas: Array[Area2D] = clicker.get_overlapping_areas()
	for area: Area2D in overlapping_areas:
		if area is Asteroid:
			(area as Asteroid).take_damage()


func _on_start_button_pressed() -> void:
	start_screen.visible = false
	spawn_asteroids()
	clicker_timer.start()
