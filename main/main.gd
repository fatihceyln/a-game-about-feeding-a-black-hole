extends Node2D
class_name Main

const ASTEROID: PackedScene = preload("uid://db1ixbef0ki6")

@export var asteroid_count: int = 35
@export var spawn_radius_range: Vector2 = Vector2(160, 600)
@export var session_duration: float = 20

@onready var black_hole: BlackHole = $BlackHole
@onready var clicker: Clicker = $Clicker
@onready var clicker_timer: Timer = $ClickerTimer
@onready var session_timer: Timer = $SessionTimer
@onready var start_screen: Control = %StartScreen
@onready var game_over_screen: Control = %GameOverScreen
@onready var timer_label: Label = %TimerLabel
@onready var kill_count_label: Label = %KillCountLabel


var session_time: float = 0
var kill_count: int = 0

func _process(delta: float) -> void:
	clicker.global_position = get_global_mouse_position()


func spawn_asteroids() -> void:
	for i: int in asteroid_count:
		var asteroid: Asteroid = ASTEROID.instantiate()
		asteroid.destroyed.connect(on_asteroid_destroyed)
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
	start_session()


func _on_session_timer_timeout() -> void:
	session_time -= session_timer.wait_time
	timer_label.text = "%.1f" % session_time
	if session_time <= 0:
		timer_label.visible = false
		game_over_screen.visible = true
		session_timer.stop()
		clicker_timer.stop()
		clear_asteroids()


func clear_asteroids() -> void:
	for node: Node in get_tree().get_nodes_in_group("asteroids"):
		node.queue_free()


func _on_play_again_button_pressed() -> void:
	game_over_screen.visible = false
	start_session()


func start_session() -> void: 
	kill_count = 0
	timer_label.visible = true
	
	spawn_asteroids()
	clicker_timer.start()
	
	session_time = session_duration
	session_timer.start()


func on_asteroid_destroyed() -> void:
	kill_count += 1
	kill_count_label.text = "You killed %d asteroids" % kill_count
