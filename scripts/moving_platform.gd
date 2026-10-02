extends AnimatableBody2D

# How far the platform drifts to each side, in pixels.
@export var drift_distance = 54.0
# Seconds for one full trip out and back.
@export var drift_time = 4.0

var start_position = Vector2.ZERO
var time_passed = 0.0


func _ready() -> void:
	start_position = position


func _physics_process(delta: float) -> void:
	time_passed += delta
	position.x = start_position.x + sin(TAU * time_passed / drift_time) * drift_distance
