extends Area2D

# on sends you up to the ceiling, off drops you back down
@export var flip_up = true


func _on_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	if flip_up:
		body.flip_gravity(-1)
	else:
		body.flip_gravity(1)
	# flipped lever sprite
	$Sprite2D.frame = 66
