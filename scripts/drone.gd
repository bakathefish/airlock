extends Area2D

const SPEED = 40.0
const RANGE = 54.0

var start_x = 0.0
var direction = 1


func _ready() -> void:
	start_x = position.x


func _process(delta: float) -> void:
	position.x += direction * SPEED * delta
	if position.x > start_x + RANGE:
		direction = -1
		$Sprite2D.flip_h = true
	elif position.x < start_x - RANGE:
		direction = 1
		$Sprite2D.flip_h = false


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
